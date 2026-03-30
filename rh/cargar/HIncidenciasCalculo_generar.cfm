<!--- /
******************************************
CARGA INICIAL DE DEDUCCIONESCALCULO
	FECHA    DE    CREACIÓN:    23/03/2007
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
	insert into HIncidenciasCalculo(
		RCNid, DEid, 
		CIid, ICfecha, 
		ICvalor, ICfechasis, 
		Usucodigo, Ulocalizacion, 
		ICcalculo, ICmontoant, 
		ICmontores, CFid, Ifechacontrol, ICespecie)
	select b.RCNid, c.DEid, 
		e.CIid, #Gvar.table_name#.CDRHHICfecha, 
		#Gvar.table_name#.CDRHHICcantidad , <!---#Gvar.table_name#.CDRHHICvalor, --->
		#Gvar.table_name#.CDRHHICfdesde,  
		#Session.Usucodigo#, '00', 
		0, #Gvar.table_name#.CDRHHICvalor, 
		#Gvar.table_name#.CDRHHICvalor,<!----#Gvar.table_name#.CDRHHICvalor,---->
		f.CFid,#Gvar.table_name#.CDRHHIfechacontrol,#Gvar.table_name#.CDRHHICespecie
	from #Gvar.table_name#
		inner join HRCalculoNomina b
		on b.Ecodigo = #Gvar.Ecodigo#
		and b.RCdesde = #Gvar.table_name#.CDRHHICfdesde
		and b.RChasta = #Gvar.table_name#.CDRHHICfhasta
		and rtrim(b.Tcodigo) = rtrim(#Gvar.table_name#.CDRHHICnomina)
			
		inner join DatosEmpleado c
		on c.DEidentificacion = #Gvar.table_name#.CDRHHICidentificacion
		and c.Ecodigo = b.Ecodigo
			
		inner join CIncidentes e
		on rtrim(e.CIcodigo) = rtrim(#Gvar.table_name#.CDRHHICincidencia)
		and e.Ecodigo = b.Ecodigo
		
		left outer join CFuncional f
		on rtrim(f.CFcodigo) = rtrim(#Gvar.table_name#.CDRHHICcfuncional)
		and f.Ecodigo = b.Ecodigo
		
	where  CDPcontrolv = 1
	and CDPcontrolg = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>