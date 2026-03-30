<!--- Solo inserta los registros de Default para cuando se inserta un Proceso en la tabla de WfProcess --->

	insert WfApplication 
	(ProcessId, Name, Description, 
	Type, Location,Documentation, Command)
	values (
		@procesoNuevo,
		'AplicaAccion',
		'Ejecuta la aplicación de una acción', 
		'PROCEDURE', 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.DSN#">, 
		'Ejecuta un llamado al procedimiento de la acción',
		'rh_AplicaAccion_danim'
	)
	
	declare @aplicacion numeric	
	Select @aplicacion = @@identity

	insert WfInvocation 
	(ActivityId, ApplicationId)
	values (@activFinal, @aplicacion)

	<!--- Parametros  --->
	insert WfFormalParameter 
	(ApplicationId, Number, Name, Description)
	values (@aplicacion, 1, 'Ecodigo', 'Empresa')

	insert WfActualParameter 
	(ActivityId, ApplicationId, ParameterId, Value)
	values (
	@activFinal, 
	@aplicacion, 
	@@identity, 
	'Ecodigo'
	)

	insert WfFormalParameter 
	(ApplicationId, Number, Name, Description)
	values (@aplicacion, 2, 'RHAlinea', '# Acción')
	
	insert WfActualParameter 
	(ActivityId, ApplicationId, ParameterId, Value)
	values (
	@activFinal, 
	@aplicacion, 
	@@identity, 
	'RHAlinea'
	)

	insert WfFormalParameter 
	(ApplicationId, Number, Name, Description)
	values (@aplicacion, 3, 'Usucodigo', 'Usuario que invoca')

	insert WfActualParameter 
	(ActivityId, ApplicationId, ParameterId, Value)
	values (
	@activFinal, 
	@aplicacion, 
	@@identity, 
	'Usucodigo'
	)

	insert WfFormalParameter 
	(ApplicationId, Number, Name, Description)
	values (@aplicacion, 4, 'Ulocalizacion', 'Usuario que invoca')

	insert WfActualParameter 
	(ActivityId, ApplicationId, ParameterId, Value)
	values (
	@activFinal, 
	@aplicacion, 
	@@identity, 
	'Ulocalizacion'
	)	