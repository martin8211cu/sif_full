<!--- /
******************************************
CARGA INICIAL DE DEDUCCIONESEMPLEADO
	FECHA    DE    CREACIÓN:    22/03/2007
	CREADO   POR:   DORIAN   ABARCA  GÓMEZ
******************************************
*********************************
Archivo   de  generaración  final
Este   archivo   requiere es para 
realizar  la  copia  final  de la 
tabla temporal a la tabla real.
*********************************
--->
<cfquery datasource="#Gvar.Conexion#">
	insert into DeduccionesEmpleado
	   (DEid, Ecodigo, SNcodigo, 
		TDid, Ddescripcion, Dmetodo,
	    Dvalor, Dfechaini, Dfechafin, 
		Dmonto, Dtasa, Dsaldo, Dmontoint, 
	    Destado, Usucodigo, Ulocalizacion, 
		Dcontrolsaldo, Dactivo, Dreferencia)
	select 
	    d.DEid, #Gvar.Ecodigo#, b.SNcodigo, 
	    c.TDid, c.TDdescripcion, #Gvar.table_name#.CDRHHDmetodo, 
	    #Gvar.table_name#.CDRHHDEvalor, #Gvar.table_name#.CDRHHDEfdesde, #Gvar.table_name#.CDRHHDEfhasta, 
		0, coalesce(#Gvar.table_name#.CDRHHDEinteres,0), 0, coalesce(#Gvar.table_name#.CDRHHDEinteres,0), 
	    0, #Session.Usucodigo#, '00', 
		0, 1, {fn concat(#Gvar.table_name#.CDRHHDEdeduccion ,{fn concat(' - ', <cf_dbfunction name="date_format" args="#Gvar.table_name#.CDRHHDEfdesde,DD/MM/YYYY" datasource="#Gvar.Conexion#">)})}
	from #Gvar.table_name#
		inner join SNegocios b
		on b.Ecodigo = #Gvar.Ecodigo#
		and rtrim(ltrim(b.SNnumero)) = rtrim(ltrim(#Gvar.table_name#.CDRHHDEsocio))
		
		inner join TDeduccion c
		on rtrim(ltrim(c.TDcodigo)) = rtrim(ltrim(#Gvar.table_name#.CDRHHDEdeduccion))
		and c.Ecodigo = b.Ecodigo
		
		inner join DatosEmpleado d
		on d.DEidentificacion = #Gvar.table_name#.CDRHHDEidentificacion
		and d.Ecodigo = b.Ecodigo
		 
	where  CDPcontrolv = 1
	and CDPcontrolg = 0
	and #Gvar.table_name#.Ecodigo  = #Gvar.Ecodigo#
</cfquery>