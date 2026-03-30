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
<cfquery name="rsEmpresas" datasource="#Gvar.Conexion#">
	select Mcodigo
	from Empresas
	where Ecodigo  = #Gvar.Ecodigo#
</cfquery>
<cfquery datasource="#Gvar.Conexion#">
	insert into HDeduccionesCalculo
		(Did, RCNid, DEid, DCvalor, DCinteres, DCmontoant, DCcalculo, 
		DCsaldo, Mcodigo)
	select 
		f.Did, d.RCNid, c.DEid, #Gvar.table_name#.CDRHHDCvalor, coalesce(#Gvar.table_name#.CDRHHDCinteres,0), 
		0, 0, 0, #rsEmpresas.Mcodigo#
	from #Gvar.table_name#
		
		inner join HRCalculoNomina b
		on b.RCNid = #Gvar.table_name#.CDRHHDCRCNid			
        
		inner join DatosEmpleado c
		on c.DEidentificacion = #Gvar.table_name#.CDRHHDCidentificacion
		and c.Ecodigo = b.Ecodigo
			
		inner join HSalarioEmpleado d
		on d.RCNid = b.RCNid
		and d.DEid = c.DEid
		
		inner join TDeduccion e
		on e.TDcodigo = #Gvar.table_name#.CDRHHDCdeduccion
		and e.Ecodigo = b.Ecodigo
		
		inner join DeduccionesEmpleado f
		on f.TDid = e.TDid
		and f.DEid = c.DEid
		<!--- and f.Dfechaini between b.RCdesde and b.RChasta --->
		and b.RCdesde = f.Dfechaini

	where  CDPcontrolv = 1
	and CDPcontrolg = 0
	and #Gvar.table_name#.Ecodigo = #Gvar.Ecodigo#
</cfquery>