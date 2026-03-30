<!--- 
******************************************
CARGA INICIAL DE EMPLEADOS
	FECHA    DE    CREACIÓN:    28/02/2007
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
	where Ecodigo = #Gvar.Ecodigo#
</cfquery>

<cfquery datasource="#Gvar.Conexion#">
	insert into DatosEmpleado (
			Ecodigo, 		Bid, 			NTIcodigo, 		DEidentificacion, 	
			DEnombre, 		DEapellido1, 	DEapellido2, 	DEcuenta, 		
			CBcc, 			Mcodigo, 		DEdireccion, 	DEtelefono1, 	
			DEtelefono2, 	DEemail, 		DEcivil, 		DEfechanac, 		
			DEsexo, 		DEobs1, 		DEobs2, 		DEobs3, 
			DEobs4,         DEobs5,			
			DEdato1, 		DEdato2, 		DEdato3, 		DEdato4, 			
			DEdato5, 		DEdato6,        DEdato7,        DEinfo1,
			DEinfo2, 		DEinfo3,        DEinfo4,        DEinfo5,
			DEtarjeta, 		DEfanuales, 	BMUsucodigo, 	Usucodigo,
			Ulocalizacion,	DEcantdep, 		DEsistema, 		CBTcodigo, DESeguroSocial,DEsdi, DEtipoSalario, DEtipocontratacion,
            RFC, CURP,ZEid,Ppais
			)
	select 	
			#Gvar.Ecodigo#, 		CDRHDEbanco, 			CDRHDEtipoidentificacion, 	CDRHDEidentificacion, 	
			CDRHDEnombre, 			CDRHDEapellido1, 		CDRHDEapellido2,			CDRHDEcuenta, 	
			coalesce(CDRHDEcbcc, CDRHDEcuenta), 			coalesce(CDRHDEmoneda, #rsEmpresas.Mcodigo#),	
			CDRHDEdireccion, 		CDRHDEtelefono1, 		CDRHDEtelefono2, 			CDRHDEcorreo, 	
			CDRHDEecivil, 			CDRHDEfnacimiento, 		CDRHDEsexo, 				CDRHDEdatovargde1, 	
			CDRHDEdatovargde2, 		CDRHDEdatovargde3, 	    CDRHDEdatovargde4,          CDRHDEdatovargde5,
			CDRHDEdatovarpeq1, 		CDRHDEdatovarpeq2, 	    CDRHDEdatovarpeq3, 		    CDRHDEdatovarpeq4, 		
			CDRHDEdatovarpeq5, 	    CDRHDEdatovarpeq6,      CDRHDEdatovarpeq7,          CDRHDEdatovarmed1, 	   
		    CDRHDEdatovarmed2, 		CDRHDEdatovarmed3, 	    CDRHDEdatovarmed4,          CDRHDEdatovarmed5,     
		    CDRHDEtarjeta, 			CDRHDEfanualidad,       #Session.Usucodigo#,	    #Session.Usucodigo#,	
			'00',						0, 			        1, 						    CDRHDEtipocuenta ,      
			CDRHDEcarneseguro,CDRHDEsdi,CDRHDEtiposalario,CDRHDEtipocontratacion,
            CDRHDErfc, CDRHDEcurp,a.ZEid,CDRHDEnacionalidad
	from #Gvar.table_name# 
    	left join ZonasEconomicas a
          on a.ZEcodigo = CDRHDEzeid
           and CEcodigo = #session.CEcodigo#
	where CDPcontrolv = 1
	and CDPcontrolg = 0
	and Ecodigo=#Gvar.Ecodigo#
</cfquery>
<!---SML.Modificacion para agregar el Tipo de Empleado (Confianza, Sindicalizado y No Sindicalizado)--->

<cfquery datasource="#Gvar.Conexion#">
	insert into EmpleadosTipo 
			(DEid, TEid, ETNumConces)
	select 	DEid, 	TEid, 0
	from #Gvar.table_name# a
		inner join DatosEmpleado b
			on b.DEidentificacion = a.CDRHDEidentificacion
            	and a.Ecodigo = b.Ecodigo
        inner join TiposEmpleado c
        	on a.CDRHDEtipoempleado = c.TEcodigo
            	and a.Ecodigo = c.Ecodigo
	where b.Ecodigo = #Gvar.Ecodigo#
	and CDPcontrolv = 1
	and CDPcontrolg = 0
</cfquery> 





<!--- 
***06/006/2007***
***Se va a pasar para Acciones de Personal***
***Solicitado  por  Juan Carlos Gutierrez***
<cfquery datasource="#Gvar.Conexion#">
	insert into EVacacionesEmpleado 
			(DEid, 	EVfantig, 			EVfecha, 
			EVmes, 						
			EVdia, 							
			EVinicializar, 	BMUsucodigo)
	select 	DEid, 	CDRHDEfanualidad, 	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
			<cf_dbfunction name="date_part" args="mm,CDRHDEfanualidad" datasource="#Gvar.Conexion#">, 
			<cf_dbfunction name="date_part" args="dd,CDRHDEfanualidad" datasource="#Gvar.Conexion#">, 
			0, 				#session.Usucodigo#
	from #Gvar.table_name# a
		inner join DatosEmpleado b
			on b.DEidentificacion = a.CDRHDEidentificacion
	where Ecodigo = #Gvar.Ecodigo#
	and CDPcontrolv = 1
	and CDPcontrolg = 0
</cfquery> 
--->