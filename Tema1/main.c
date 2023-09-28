#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"

void get_operations(void (**)(void *));

void print_Tire(tire_sensor *T)//Afisare Tire Sensor
{
	printf("Tire Sensor\n");
	printf("Pressure: %.2lf\n", T->pressure);
	printf("Temperature: %.2lf\n", T->temperature);
	printf("Wear Level: %d%%\n", T->wear_level);
	printf("Performance Score: ");
	if (T->performace_score > 0 && T->performace_score < 11)
		printf("%d\n", T->performace_score);
	else
		printf("Not Calculated\n");
}

void print_PMU(power_management_unit *PMU)//Afisare PMU Sensor
{
	printf("Power Management Unit\n");
	printf("Voltage: %.2lf\n", PMU->voltage);
	printf("Current: %.2lf\n", PMU->current);
	printf("Power Consumption: %.2lf\n", PMU->power_consumption);
	printf("Energy Regen: %d%%\n", PMU->energy_regen);
	printf("Energy Storage: %d%%\n", PMU->energy_storage);
}

int valid0(tire_sensor *T)//Verific daca Tire Sensor e valid
{
	if (T->pressure < 19 || T->pressure > 28)
		return 0;
	if (T->temperature < 0 || T->temperature > 120)
		return 0;
	if (T->wear_level < 0 || T->wear_level > 100)
		return 0;
	return 1;
}

int valid1(power_management_unit *PMU)//Verific daca PMU Sensor e valid
{
	if (PMU->voltage < 10 || PMU->voltage > 20)
		return 0;
	if (PMU->current < -100 || PMU->current > 100)
		return 0;
	if (PMU->power_consumption < 0 || PMU->power_consumption > 1000)
		return 0;
	if (PMU->energy_regen < 0 || PMU->energy_regen > 100)
		return 0;
	if (PMU->energy_storage < 0 || PMU->energy_storage > 100)
		return 0;
	return 1;
}

int valid(sensor *S)//Verific daca PMU/Tire Sensor e valid
{
	if (S->sensor_type == 0)
		return valid0(S->sensor_data);
	return valid1(S->sensor_data);
}

void read_binary_file(sensor **s, int *nr_sens, char const *argv_1)
{
	FILE *in = fopen(argv_1, "rb");
	int i;
	enum sensor_type type;
	//Citire numar senzori
	fread(nr_sens, sizeof(int), 1, in);
	*s = malloc(*nr_sens * sizeof(**s));
	for (i = 0; i < *nr_sens; i++) {
		//Citire Sensor Type
		fread(&type, sizeof(type), 1, in);
		(*s + i)->sensor_type = type;
		//Citire PMU/Tire Sensor
		if (type == 1) {
			//Citire PMU Sensor
			(*s + i)->sensor_data = (power_management_unit *)
			malloc(sizeof(power_management_unit));
			//
			fread((*s + i)->sensor_data, sizeof(power_management_unit),
			1, in);
		} else {
			//Citire Tire Sensor
			(*s + i)->sensor_data = (tire_sensor *)
			malloc(sizeof(tire_sensor));
			//
			fread((*s + i)->sensor_data, sizeof(tire_sensor), 1, in);
		}
		//Citire nr_operatii
		fread(&((*s + i)->nr_operations), sizeof(int), 1, in);
		//
		(*s + i)->operations_idxs = malloc
		((*s + i)->nr_operations * sizeof(int));
		//Citirea vectorului cu operatii
		fread((*s + i)->operations_idxs, sizeof(int),
		(*s + i)->nr_operations, in);
		//
	}
	//Inchid fisierul
	fclose(in);
}

void sort_sensors(sensor **s, int nr_sens)
{
	int i, j;
	int *prioritati = malloc(nr_sens * sizeof(int));
	//creez vectorul de prioritati
	int tire = -1, pmu = nr_sens;
	for (i = 0; i < nr_sens; i++)
		if (((*s + i))->sensor_type == 1) {
			prioritati[i] = pmu;
			pmu--;
		} else {
			prioritati[i] = tire;
			tire--;
		}
	//sortez descrescator dupa vectorul de prioritati
	int aux_int;
	sensor aux;
	for (i = 0; i < nr_sens; i++)
		for (j = i + 1; j < nr_sens; j++)
			if (prioritati[i] < prioritati[j]) {
				aux = *(*s + i);
				*(*s + i) = *(*s + j);
				*(*s + j) = aux;
				//
				aux_int = prioritati[i];
				prioritati[i] = prioritati[j];
				prioritati[j] = aux_int;
			}
	free(prioritati);
	//Mai multe detalii in README
}

void print_command(sensor **s, int nr_sens)//Afisare PMU/Tire Sensor
{
	int index;
	scanf("%d", &index);
	if (index < 0 || index >= nr_sens)
		printf("Index not in range!\n");
	else if ((*s + index)->sensor_type == 0)
		print_Tire((*s + index)->sensor_data);
	else
		print_PMU((*s + index)->sensor_data);
}

void analyze_command(sensor **s, int nr_sens, void (**operatii)(void *))
{
	int index, *index_operations; //index_operations=pentru analyze
	scanf("%d", &index);
	if (index < 0 || index >= nr_sens)
		printf("Index not in range!\n");
	else {
		index_operations = (*s + index)->operations_idxs;
		for (int j = 0; j < (*s + index)->nr_operations; j++)
			(operatii[index_operations[j]])((*s + index)->sensor_data);//*?
	}
}

void clear_command(sensor ***s, int **nr_sens)//Elimin senzorii invalizi
{
	for (int i = 0; i < **nr_sens; i++)
		if (!valid((**s + i))) {
			free((**s + i)->sensor_data);
			free((**s + i)->operations_idxs);
			//
			for (int j = i + 1; j < **nr_sens; j++)
				(**s)[j - 1] = (**s)[j];
			(**nr_sens)--;
			i--;
		}
	**s = realloc(**s, **nr_sens * sizeof(***s));
}

void free_memory(sensor ***s, int *nr_sens)//Eliberez vectorul de senzori
{
	for (int i = 0; i < *nr_sens; i++) {
		free((**s + i)->sensor_data);
		free((**s + i)->operations_idxs);
	}
	free(**s);
}

void read_input_and_solve(sensor **s, int *nr_sens)
{
	//Initializare date
	char *comanda = malloc(20*sizeof(*comanda));
	void (**operatii)(void *data);
	operatii = malloc(8*sizeof(*operatii));
	get_operations(operatii);
	//Citire si rezolvare
	while (1) {
		scanf("%s", comanda);
		if (strcmp(comanda, "print") == 0)
			print_command(s, *nr_sens);
		else if (strcmp(comanda, "analyze") == 0)
			analyze_command(s, *nr_sens, operatii);
		else if (strcmp(comanda, "clear") == 0)
			clear_command(&s, &nr_sens);
		else if (strcmp(comanda, "exit") == 0) {
				free_memory(&s, nr_sens);
				free(operatii);
				free(comanda);
				break;
			}
	}
}

int main(int argc, char const *argv[])
{
	sensor *S;
	int nr_sensors;
	//Citire fisier binar
	read_binary_file(&S, &nr_sensors, argv[1]);
	//Sortez senzorii
	sort_sensors(&S, nr_sensors);
	//Citire date din stdin si rezolvare problema
	read_input_and_solve(&S, &nr_sensors);
	return 0;
}
