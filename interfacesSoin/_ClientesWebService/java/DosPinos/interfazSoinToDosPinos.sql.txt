/* 
   1. El procedimiento interfazSoinToDosPinos, es un procedimiento generico fijo que 
      debe estar almacenado en el esquema de Interfaces, y su objetivo es lanzar a 
      ejecutar el procedimiento específico para procesar la tabla de salida de cada 
      interfaz.
   2. El nombre de los procedimientos específicos los asigna Dos Pinos.
      Como ejemplo se colocaron dospinos.procesaInterfaz101 y 
      dospinos.procesaInterfaz102, que son procedimientos propios de los sistemas 
      de Dos Pinos y deben estar almacenados en el esquema destino donde se va a 
      procesar la tabla de salida.  
   3. Dos Pinos es responsable de modificar el procedimiento genérico 
      interfazSoinToDosPinos por cada nueva interfaz que se desea procesar para 
      indicar el nombre de los procedmientos específicos.
*/	

create or replace procedure interfazSoinToDosPinos
	(NumeroInterfaz NUMBER, ID NUMBER) AS
BEGIN
	IF NumeroInterfaz = 101 THEN
		dospinos.procesaInterfaz101(ID);
	ELSIF NumeroInterfaz = 102 THEN
		dospinos.procesaInterfaz102(ID);
	ELSE
		raise_application_error(-20000, 'No se ha definido el procedimiento para la Interfaz=' || NumeroInterfaz || ' en interfazSoinToDosPinos');
	END IF;
END;
/
