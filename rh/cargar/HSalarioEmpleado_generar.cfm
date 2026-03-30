<!--- /
******************************************
CARGA INICIAL DE HSALARIOEMPLEADO
	FECHA    DE    CREACIÓN:    20/03/2007
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
	Insert into HSalarioEmpleado
       (DEid, 
		RCNid, 
		SEcalculado, 
		SEsalariobruto, 
		SEincidencias, 
        SEcargasempleado, 
		SEcargaspatrono, 
		SErenta, 
        SEdeducciones, 
		SEliquido, 
		SEacumulado, 
		SEproyectado, 
        SEinodeduc, 
		SEinocargas, 
		SEinorenta)
	select 
        c.DEid, 
		b.RCNid, 
		1, -- INDICA QUE YA ESTA CALCULADO
		isnull(CDRHHSEsalariobruto,0), 
		isnull(CDRHHSEincidencias,0), 
        isnull(CDRHHSEcargasemp,0), 
		isnull(CDRHHSEcargaspat,0), 
		isnull(CDRHHSErenta,0), 
		isnull(CDRHHSEdeducciones,0), 
		CDRHHSEliquido, 
        isnull(CDRHHSEacumulado,0), 
		isnull(CDRHHSEproyectado,0), 
		isnull(CDRHHSEincnodeduc,0), 
		isnull(CDRHHSEincnocargas,0), 
		isnull(CDRHHSEincnorenta,0)
	from CDRHHSalarioEmpleado a
        inner join HRCalculoNomina b
			on b.RCdesde = a.CDRHHSEfdesde
	    	and b.RChasta = a.CDRHHSEfhasta
    	    and b.Tcodigo = a.CDRHHSEnomina
    	    and b.Ecodigo = a.Ecodigo                   --Katy
    	    and b.Ecodigo = #Gvar.Ecodigo#
    	    inner join DatosEmpleado c
			on c.DEidentificacion = a.CDRHHSEidentificacion
			and c.Ecodigo = a.Ecodigo					-- Katy
			and c.Ecodigo = #Gvar.Ecodigo#
	where  a.Ecodigo = #Gvar.Ecodigo#				-- Katy
		   and CDPcontrolv = 1
		   and CDPcontrolg = 0
</cfquery>

<!---SML. Importar el Subsidio Tablas de las Nominas--->
<cfquery datasource="#Gvar.Conexion#">
	Insert into HRHSubsidio
       (RCNid,
       	DEid, 
        Ecodigo,
		RHSvalor,
        RHSFechaDesde,
        RHSFechaHasta)
	select 
    	b.RCNid,
        c.DEid,
        #Gvar.Ecodigo#, 
		isnull(CDRHHSEsubsidiotablas,0), 
        a.CDRHHSEfdesde,
        a.CDRHHSEfhasta
	from CDRHHSalarioEmpleado a
        inner join HRCalculoNomina b
			on b.RCdesde = a.CDRHHSEfdesde
	    	and b.RChasta = a.CDRHHSEfhasta
    	    and b.Tcodigo = a.CDRHHSEnomina
    	    and b.Ecodigo = a.Ecodigo                   
    	    and b.Ecodigo = #Gvar.Ecodigo#
    	    inner join DatosEmpleado c
			on c.DEidentificacion = a.CDRHHSEidentificacion
			and c.Ecodigo = a.Ecodigo					
			and c.Ecodigo = #Gvar.Ecodigo#
	where  a.Ecodigo = #Gvar.Ecodigo#				
		   and CDPcontrolv = 1
		   and CDPcontrolg = 0
</cfquery>