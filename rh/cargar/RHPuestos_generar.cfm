<!--- 
	******************************************
	* CARGA INICIAL DE RHPUESTOS
	* FECHA DE CREACIÓN:	09/04/2007
	* CREADO POR:   		RANDALL COLOMER V.
	******************************************
	******************************************
	* Archivo de generaración final
	* Este archivo requiere es para
	* realizar la copia final de la
	* tabla temporal a la tabla real.
	******************************************
--->


<!--- Declaración de variables --->
<cfset LvarFecha = CreateDate(1900,01,01)>
	
<!--- Inserta los Datos en la Tabla MaestroPuestosP --->
<cfquery datasource="#Gvar.Conexion#">
	insert into RHMaestroPuestoP (
		Ecodigo, 
		RHMPPcodigo, 
		RHMPPdescripcion, 
		BMfecha, 
		BMUsucodigo)
	select 	#Gvar.Ecodigo#, 
			{fn concat('PP-',ltrim(rtrim(#Gvar.table_name#.CDRHHPcodigo)))}, 
			#Gvar.table_name#.CDRHHPdescripcion, 
			#LvarFecha#, 
			0
    from  #Gvar.table_name#
	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#		
</cfquery>

<!--- Inserta los Datos en la Tabla de Puestos --->
<cfquery datasource="#Gvar.Conexion#">
	insert into RHPuestos (
		Ecodigo, 
		RHPcodigo, 
		RHPdescpuesto, 
		RHTPid, 
		RHOcodigo, 
		RHPEid, 
		RHPactivo, 
		RHMPPid, 
		BMfecha, 
		BMusuario)
		select 	#Gvar.Ecodigo#, 
				#Gvar.table_name#.CDRHHPcodigo, 
				#Gvar.table_name#.CDRHHPdescripcion,
				null, 
				#Gvar.table_name#.CDRHHPocupacion,
				null,
				1, 
				null, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">, 
				0
    from  #Gvar.table_name#
	where CDPcontrolv = 1
		and CDPcontrolg = 0
		and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cfquery datasource="#Gvar.Conexion#">
	update RHPuestos set
	RHPEid = (Select Max(RHPEid)
			  from RHPuestosExternos a, #Gvar.table_name# b
			  Where RHPuestos.Ecodigo= a.Ecodigo
			  and b.CDRHHPcodigo = RHPuestos.RHPcodigo
			  and a.RHPEcodigo = b.CDRHHPcodigoExt
			  and b.Ecodigo = a.Ecodigo)
	Where Ecodigo=#Gvar.Ecodigo#
	and RHPEid is null
</cfquery>

<cfquery datasource="#Gvar.Conexion#">
update  RHPuestos 
set RHTPid = (select tp.RHTPid 
			  from RHTPuestos tp, #Gvar.table_name# a
			  Where RHPuestos.Ecodigo = a.Ecodigo
			  and a.CDRHHPcodigo = RHPuestos.RHPcodigo
			  and tp.RHTPcodigo = a.CDRHHPtipoPuesto
			  and tp.Ecodigo=a.Ecodigo)
Where RHPuestos.Ecodigo=#Gvar.Ecodigo#
and RHPuestos.RHTPid is null
</cfquery>




<!--- Relacion el RHPuesto con el MaestroPuestosP --->
<cfquery name="rsDatos" datasource="#Gvar.Conexion#">
	select a.RHMPPcodigo, a.RHMPPid
	from RHMaestroPuestoP a, RHPuestos b
	where a.RHMPPcodigo = {fn concat('PP-',ltrim(rtrim(b.RHPcodigo)))}
		and a.Ecodigo = b.Ecodigo
		and a.Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cfif isdefined("rsDatos") and rsDatos.recordcount GT 0 >
	<cfloop query="rsDatos">
		<cfquery datasource="#Gvar.Conexion#">
			update RHPuestos
			set RHMPPid = #rsDatos.RHMPPid#
			where exists (	select 1
							from RHMaestroPuestoP a
							where   a.RHMPPcodigo = {fn concat('PP-',ltrim(rtrim(RHPuestos.RHPcodigo)))}
								and a.RHMPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.RHMPPcodigo#"> 
								and a.Ecodigo = #Gvar.Ecodigo#
								and a.Ecodigo = RHPuestos.Ecodigo )
		</cfquery>
	</cfloop>
</cfif>		
