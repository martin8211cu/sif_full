<!--- Solo inserta los registros de Default para un proceso de RH en el modelo de tramites --->

	insert WfDataField 
	(ProcessId, Name, Description, InitialValue, Length, Datatype, Prompt, Label)
	values (
		@procesoNuevo,
		'DEid',
		'Número de empleado',
		'',
		8, 
		'NUMERIC', 
		1, 
		'Empleado'
	)


	insert WfDataField 
	(ProcessId, Name, Description, InitialValue, Length, Datatype, Prompt, Label)
	values (
		@procesoNuevo,
		'Ecodigo',
		'Código de empresa',
		'',		
		8, 
		'NUMERIC', 
		1, 
		'Empresa'
	)


	insert WfDataField 
	(ProcessId, Name, Description, InitialValue, Length, Datatype, Prompt, Label)
	values (
		@procesoNuevo,
		'DEnombre',
		'Nombre del empleado',
		'',
		16, 
		'STRING', 
		1, 
		'Nombre'
	)


	insert WfDataField 
	(ProcessId, Name, Description, InitialValue, Length, Datatype, Prompt, Label)
	values (
		@procesoNuevo,
		'RHAlinea',
		'Número de acción',
		'',
		16, 
		'NUMERIC', 
		1, 
		'Acción'
	)

	insert WfDataField 
	(ProcessId, Name, Description, InitialValue, Length, Datatype, Prompt, Label)
	values (
		@procesoNuevo,
		'Usucodigo',
		'Usuario que inicia trámite',
		'',
		11, 
		'NUMERIC', 
		1, 
		'Usuario(id)'
	)

	insert WfDataField 
	(ProcessId, Name, Description, InitialValue, Length, Datatype, Prompt, Label)
	values (
		@procesoNuevo,
		'Ulocalizacion',
		'Usuario que inicia trámite',
		'',
		2, 
		'STRING', 
		1, 
		'Usuario(loc)'
	)
	