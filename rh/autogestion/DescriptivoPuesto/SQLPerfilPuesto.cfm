<!--- <cf_dump var="#Form#"> ---> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado2"
	Default="Información sobre el perfil de puesto creado"
	returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado2"/>


<cfif isdefined("Url.btnNuevo") and not isdefined("Form.btnNuevo")>
	<cfparam name="Form.btnNuevo" default="#Url.btnNuevo#">
	<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
		<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
	</cfif>
	<cfif isdefined("Url.USUARIO") and not isdefined("Form.USUARIO")>
		<cfparam name="Form.USUARIO" default="#Url.USUARIO#">
	</cfif>
</cfif>
<!--- NUEVO PERFIL DEL DESCRIPTIVO DEL PUESTO --->
<cfif isdefined("form.btnNuevo")>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into RHDescripPuestoP(
				RHPcodigo,
				Ecodigo,
				RHDPmision,
				RHDPobjetivos,
				Estado,
				UsuarioAsesor,
				FechaModAsesor,
				BMusumod,     	 
				BMfechamod		
				)
			select 
				'#form.RHPcodigo#' as RHPcodigo, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo ,
				RHDPmision,
				RHDPobjetivos,
				10,
				<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				 <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			from RHPuestos a
			left outer join RHDescriptivoPuesto b
				on  a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo = b.Ecodigo
			where a.RHPcodigo = '#form.RHPcodigo#'
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" datasource="#session.DSN#">
		<cfset Form.RHDPPid = rsInsert.identity>
		<!--- Inserta los datos variables del perfil actual del puesto --->
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into RHDVPuestoP (RHDPPid,RHEDVid,RHDDVlinea,RHDDVvalor,RHDVPorden,BMUsucodigo,fechaalta)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">,
					RHEDVid,
					RHDDVlinea,
					RHDDVvalor,
					RHDVPorden,
					<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			from  RHDVPuesto
			where RHPcodigo = '#form.RHPcodigo#'
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 </cfquery>
		<!--- Inserta las habilidades del perfil actual del puesto --->
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into RHHabilidadPuestoP (RHHid,RHDPPid,RHNid,RHNnotamin,RHHtipo,RHHpeso,RHHpesoJefe,PCid,ubicacionB,BMUsucodigo) 
			select 
				RHHid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> as RHDPPid,
				RHNid,
				RHNnotamin,
				RHHtipo,
				RHHpeso,
				RHHpesoJefe,
				PCid,
				ubicacionB,
				<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			from  RHHabilidadesPuesto 
			where RHPcodigo = '#form.RHPcodigo#'
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 </cfquery>	
		<!--- Inserta los conicimientos del perfil actual del puesto --->
		 <cfquery name="rsInsert" datasource="#session.DSN#">
			insert into RHConocimientoPuestoP (RHDPPid,RHCid,RHNid,RHCnotamin,RHCtipo,RHCpeso,PCid,BMUsucodigo)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> as RHDPPid,
				RHCid,RHNid,RHCnotamin,RHCtipo,RHCpeso,PCid,
				<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			from RHConocimientosPuesto				
			where RHPcodigo = '#form.RHPcodigo#'
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 </cfquery>		 
		<!--- Inserta los valores del perfil actual del puesto --->
		 <cfquery name="rsInsert" datasource="#session.DSN#">
			insert into RHValorPuestoP(RHDPPid,RHDCGid,RHECGid,RHVPtipo,BMUsucodigo)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> as RHDPPid,
				RHDCGid,RHECGid,RHVPtipo,
				<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			from RHValoresPuesto				
			where RHPcodigo = '#form.RHPcodigo#'
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 </cfquery>
	</cftransaction>
	<cfoutput>
	<cfparam name="action" default="PerfilPuesto.cfm">
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="1">
			<input name="o" type="hidden" value="1">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- ELIMINAR EL PERFIL CREADO--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ELIMINARPERFIL'>
	<cftransaction>
		<!--- elimina  los datos variables del perfil propuesto--->
		<cfquery name="delete" datasource="#session.DSN#">
			delete from RHDVPuestoP
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		</cfquery>
		<!--- elimina  las habilidades del perfil propuesto--->
		<cfquery name="delete" datasource="#session.DSN#">
			delete from RHHabilidadPuestoP 
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		</cfquery>	
		<!--- elimina  los conocimientos del perfil propuesto--->
		<cfquery name="delete" datasource="#session.DSN#">
			delete from RHConocimientoPuestoP 
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		</cfquery>	
		<!--- elimina  valores del perfil propuesto--->
		<cfquery name="delete" datasource="#session.DSN#">
			delete from RHValorPuestoP 
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		</cfquery>	
		<!--- elimina el perfil propuesto--->
		<cfquery name="delete" datasource="#session.DSN#">
			delete from RHDescripPuestoP 
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
			and Estado 	  = 10
		</cfquery>			
	</cftransaction>
	<cfparam name="action" default="Puestos-lista.cfm">
	<cflocation url="#action#">
	<!--- 	
	<cfoutput>
	<form action="#action#" method="post" name="sql">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>	 --->
<!--- ASESOR APRUEBA Y SE LO PASA AL JEFE DE ASESORES (APROBACION NO RELEVANTE)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ASESORTOJEFEASESOR'>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Estado 	    = 20,
			 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsCF" datasource="#session.DSN#">
		select ltrim(rtrim(Pvalor)) as CFid  
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 700				
	</cfquery>
	
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaResponsableCF"
		CFid = "#rsCF.CFid#"
		fecha = "#Now()#"
		returnvariable="ResponsableCF">

	<cfquery name="RSPara" datasource="#session.DSN#">
		select a.UsuarioAsesor,{fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		<!--- Busca el correo del jefe del centro funcional   --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ResponsableCF#">
		</cfquery>
		
		<cfif RSPARAEmpleado.recordCount GT 0 and len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPara.UsuarioAsesor#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_enviado_para_su_aprobacion"
			Default=" fue enviado para su aprobaci&oacute;n"
			returnvariable="MSG_fue_enviado_para_su_aprobacion"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Asesor"
			Default="Asesor"
			returnvariable="MSG_Asesor"/>			
			
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="blue"> ' & MSG_fue_enviado_para_su_aprobacion & '</font></b> '  >


		
		<cfset NombreDE = NombreDE & '  ' & MSG_Asesor >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo) >
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>		
	
	
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="Puestos-lista.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPuestos-lista.cfm">
	</cfif>		
	<cflocation url="#action#">
	<!--- 	<form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML> --->
<!--- El JEFE DEL CENTRO FUNCIONAL APRUEBA Y SE LO ENVIA AL JEFE DE LOS ASESORES--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'JEFECFTOJEFEASESOR'>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Estado 	    = 30,
			 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 UsuarioJefeCF  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 FechaModJefeCF = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsCFASESOR" datasource="#session.DSN#">
		select ltrim(rtrim(Pvalor)) as CFid  
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 700				
	</cfquery>
	
	<cfquery name="rsCF" datasource="#session.DSN#">
		select a.CFid  from RHPuestos a
		inner join RHDescripPuestoP b
			on a.RHPcodigo = b.RHPcodigo
			and a.Ecodigo = b.Ecodigo
			and b.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaResponsableCF"
		CFid = "#rsCFASESOR.CFid#"
		fecha = "#Now()#"
		returnvariable="ResponsableJASESOR">
		
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaResponsableCF"
		CFid = "#rsCF.CFid#"
		fecha = "#Now()#"
		returnvariable="ResponsableCF">		

	<cfquery name="RSPara" datasource="#session.DSN#">
		select {fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		<!--- Busca el correo del jefe del centro funcional   --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ResponsableJASESOR#">
		</cfquery>
		
		<cfif RSPARAEmpleado.recordCount GT 0 and len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ResponsableCF#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_enviado_para_su_aprobacion"
			Default=" fue enviado para su aprobaci&oacute;n"
			returnvariable="MSG_fue_enviado_para_su_aprobacion"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Responsable_del_centro_funcional"
			Default="Responsable del centro funcional"
			returnvariable="MSG_Responsable_del_centro_funcional"/>			
			
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="blue"> ' & MSG_fue_enviado_para_su_aprobacion & '</font></b> '  >

		
		<cfset NombreDE = NombreDE & '  ' & MSG_Responsable_del_centro_funcional >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo) >
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>	
	
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="Puestos-lista.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPuestos-lista.cfm">
	</cfif>		
	<cflocation url="#action#">
<!--- 		<form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>	 --->
<!--- JEFE ASESOR RECHAZA--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'RECHAZADOJEFEASESOR'>	
	<cftransaction>
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHDescripPuestoP
			set  Estado 	    = 40,
				 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cftransaction>
	<cfquery name="RSPara" datasource="#session.DSN#">
		select a.UsuarioAsesor,{fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPara.UsuarioAsesor#">
		</cfquery>
		<cfif RSPARAEmpleado.recordCount GT 0 and len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del  JEFE ASESOR  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>

		<!--- 
		<cfset EmailDE   = "gustavog@soin.co.cr">
		<cfset EmailPARA = "gustavog@soin.co.cr">
		 --->

	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_rechazado"
			Default="fue rechazado"
			returnvariable="MSG_fue_rechazado"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Jefe_Asesor"
			Default="Jefe Asesor"
			returnvariable="MSG_Jefe_Asesor"/>			
			
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="red"> ' & MSG_fue_rechazado & '</font></b> '  >

		
		<cfset NombreDE = NombreDE & '  ' & MSG_Jefe_Asesor >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo) >
		
		<!--- 
		<cfset EmailDE   = "gustavog@soin.co.cr">
		<cfset EmailPARA = "gustavog@soin.co.cr">
		 --->
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>
	
	<cfparam name="action" default="ApruebaPuestos-lista.cfm">
	<cflocation url="#action#">
	<!--- 
		<form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML> --->
	
<!--- JEFE ASESOR RECHAZA--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'RECHAZADOJEFECF'>	
	<cftransaction>
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHDescripPuestoP
			set  Estado 	    = 35,
				 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cftransaction>
	<cfquery name="RSPara" datasource="#session.DSN#">
		select a.UsuarioAsesor,{fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPara.UsuarioAsesor#">
		</cfquery>
		<cfif RSPARAEmpleado.recordCount GT 0 and  len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del  JEFE CF  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_rechazado"
			Default="fue rechazado"
			returnvariable="MSG_fue_rechazado"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Encargado_del_Centro_funcional"
			Default="Encargado del Centro funcional"
			returnvariable="MSG_Encargado_del_Centro_funcional"/>			
			
		
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="red"> ' & MSG_fue_rechazado & '</font></b> '  >

		
		<cfset NombreDE = NombreDE & '  ' & MSG_Encargado_del_Centro_funcional >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo) >
		
		<!--- <cfset EmailDE   = "gustavog@soin.co.cr">
		<cfset EmailPARA = "gustavog@soin.co.cr"> --->
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>
	

	
	<cfparam name="action" default="ApruebaPuestos-lista.cfm">
	<cflocation url="#action#">
	<!--- 	<form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>	
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML> --->
<!--- ASESOR APRUEBA Y SE LO PASA AL JEFE DE CENTRO FUNCIONAL--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ASESORTOCF'>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Estado 	    = 15,
			 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">		
		 where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCF" datasource="#session.DSN#">
		select a.CFid  from RHPuestos a
		inner join RHDescripPuestoP b
			on a.RHPcodigo = b.RHPcodigo
			and a.Ecodigo = b.Ecodigo
			and b.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaResponsableCF"
		CFid = "#rsCF.CFid#"
		fecha = "#Now()#"
		returnvariable="ResponsableCF">

	<cfquery name="RSPara" datasource="#session.DSN#">
		select a.UsuarioAsesor,{fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		<!--- Busca el correo del jefe del centro funcional   --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ResponsableCF#">
		</cfquery>
		<cfif RSPARAEmpleado.recordCount GT 0 and len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPara.UsuarioAsesor#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_enviado_para_su_aprobacion"
			Default=" fue enviado para su aprobaci&oacute;n"
			returnvariable="MSG_fue_enviado_para_su_aprobacion"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Asesor"
			Default="Asesor"
			returnvariable="MSG_Asesor"/>			
			
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="blue"> ' & MSG_fue_enviado_para_su_aprobacion & '</font></b> '  >

		
		<cfset NombreDE = NombreDE & '  ' & MSG_Asesor >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo) >
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>		
	
	
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="Puestos-lista.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPuestos-lista.cfm">
	</cfif>	
	<cflocation url="#action#">
	<!--- 	<form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML> --->
<!--- EL JEFE ASESOR ANULA EL PERIFIL--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ANULAR'>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Estado 	    = 45,
			 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 UsuarioJefeAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 FechaModJefeAsesor = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			 
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="RSPara" datasource="#session.DSN#">
		select a.UsuarioAsesor,{fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPara.UsuarioAsesor#">
		</cfquery>
		<cfif RSPARAEmpleado.recordCount GT 0 and  len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del  JEFE ASESOR  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_Anulado"
			Default="fue anulado"
			returnvariable="MSG_fue_Anulado"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Jefe_de_Asesores"
			Default="Jefe de Asesores"
			returnvariable="MSG_Jefe_de_Asesores"/>			
			
		
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="red"> ' & MSG_fue_Anulado & '</font></b> '  >
		
		
		<cfset NombreDE = NombreDE & '  ' & MSG_Jefe_de_Asesores >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo) >
		
		<!--- <cfset EmailDE   = "gustavog@soin.co.cr">
		<cfset EmailPARA = "gustavog@soin.co.cr"> --->
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>	
	
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="Puestos-lista.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPuestos-lista.cfm">
	</cfif>	
	<cflocation url="#action#">
	<!--- 	<form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML> --->
<!--- GUARDA LA INFORMACION DEL PRIMER TAB--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'GUARDARTAB1'>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  RHDPmision 	= <cfqueryparam value="#form.RHDPmision#"    cfsqltype="cf_sql_longvarchar">,
			 RHDPobjetivos 	= <cfqueryparam value="#form.RHDPobjetivos#" cfsqltype="cf_sql_longvarchar">,
			 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
				 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			</cfif> 
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>
	<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- GUARDA SOLO INFORMACION --->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'OBSERVACION'>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>
		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>	
<!--- GUARDA    LA INFORMACION DEL SEGUNDO TAB (DATOS VARIABLES)--->
<cfelseif IsDefined("form.Boton")and form.Boton eq 'AGREGARDATOVARIABLE'>
	<cfquery name="existe" datasource="#session.DSN#">
		select count(RHEDVid) as registros 
		from RHDVPuestoP 
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif existe.registros NEQ 0>	
		<cfset Request.Error.Backs = 1>
		<cf_throw message="El dato que se esta seleccionando ya ha sido asignado al puesto" errorcode="5015">
	<cfelse>
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHDescripPuestoP
			set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
				 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			</cfif>			
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>		
		<cfquery name="insert" datasource="#session.DSN#">		
			insert into RHDVPuestoP(RHDPPid, RHEDVid, RHDDVlinea, BMUsucodigo, fechaalta, RHDVPorden, RHDDVvalor) 
			values (<cfqueryparam value="#form.RHDPPid#" cfsqltype="cf_sql_numeric">,				
					<cfif len(trim(form.RHEDVid))><cfqueryparam value="#form.RHEDVid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
					<cfif len(trim(form.RHDDVlinea))><cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
					<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfif len(trim(form.RHDVPorden))><cfqueryparam value="#form.RHDVPorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
					<cfif isdefined("Form.RHDDVvalor") and Len(Trim(Form.RHDDVvalor))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDDVvalor#">
					<cfelse>
						null
					</cfif>
			)		
		</cfquery>		
	</cfif>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- BORRAR    LA INFORMACION DEL SEGUNDO TAB (DATOS VARIABLES)--->
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ELIMINARDATOVARIABLE'>
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>		
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="delete" datasource="#session.DSN#">
		delete from RHDVPuestoP
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR'>
		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- MODIFICAR LA INFORMACION DEL SEGUNDO TAB (DATOS VARIABLES)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'MODIFICARDATOVARIABLE'>
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>		
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="delete" datasource="#session.DSN#">
		update RHDVPuestoP set 
			RHDVPorden = <cfif len(trim(form.RHDVPorden))><cfqueryparam value="#form.RHDVPorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
			RHDDVvalor = <cfif isdefined("Form.RHDDVvalor") and Len(Trim(Form.RHDDVvalor))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHDDVvalor#"><cfelse>null</cfif>
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR'>
		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="RHDDVlinea" type="hidden" value="#form.RHDDVlinea#">
			<input name="RHDVPorden" type="hidden" value="#form.RHDVPorden#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- INVOCAR MODO NUEVO  --->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'NUEVO'>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR'>
		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
	<form action="#action#" method="post" name="sql">
		<input name="sel"    type="hidden" value="#form.sel#">
		<input name="o" type="hidden" value="#form.o#">
		<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
		<input name="USUARIO" type="hidden" value="#form.USUARIO#">
	</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- ELIMINA LA INFORMACION DEL TERCER TAB (HABILIDAD)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ELIMINARHABILIDAD'>
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>		
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="RHHabPuestoDelete" datasource="#session.DSN#">
		delete from RHHabilidadPuestoP 
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and RHHid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid_2#">
	</cfquery>	
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- MODIFICAR LA INFORMACION DEL TERCER TAB (HABILIDAD)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'MODIFICARHABILIDAD'>
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>		
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="RHHAbPuestoUpdate" datasource="#session.DSN#">
			update RHHabilidadPuestoP
			set RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">, 
				RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">, 
				RHHtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHtipo#">, 
				RHNnotamin = <cfif len(trim(form.RHNnotamin)) >
								<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHNnotamin/100#">
							<cfelse>null</cfif>,
				RHHpeso = <cfif isdefined("form.RHHpeso") and len(trim(form.RHHpeso))>
								<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpeso#">
							<cfelse>1</cfif>,
				RHHpesoJefe = <cfif isdefined("form.RHHpesoJefe") and len(trim(form.RHHpesoJefe))>
								<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpesoJefe#">
							<cfelse>1</cfif>,			
				ubicacionB = <cfif isdefined("form.ubicacionB") and len(trim(form.ubicacionB))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacionB#"><cfelse>null</cfif>
				,PCid = <cfif isdefined("form.PCid") and len(trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif>
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
			 and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid_2#">
		</cfquery>	
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="RHHid" type="hidden" value="#form.RHHid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">			
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- GUARDA    LA INFORMACION DEL TECER  TAB (HABILIDAD)--->
<cfelseif IsDefined("form.Boton")and form.Boton eq 'AGREGARHABILIDAD'>
	<cfquery name="existe" datasource="#session.DSN#">
		select count(RHHid) as registros 
		from RHHabilidadPuestoP a
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> 
		and a.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
	</cfquery>
	<cfif existe.registros NEQ 0>	
		<cfset Request.Error.Backs = 1>
		<cf_throw message="La habilidad ya ha sido asignado al puesto" errorcode="5020">
	<cfelse>
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHDescripPuestoP
			set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
				 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			</cfif>			
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>		
		<cfquery name="RHHabPuestoInsert" datasource="#session.DSN#">
			insert into RHHabilidadPuestoP(RHDPPid,  RHHid, RHNid, RHHtipo, RHNnotamin, RHHpeso,RHHpesoJefe, ubicacionB, PCid)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHtipo#">,
					<cfif len(trim(form.RHNnotamin)) >
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHNnotamin/100#">
					<cfelse>null</cfif>, 
					<cfif isdefined("form.RHHpeso") and len(trim(form.RHHpeso))>
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpeso#">
					<cfelse>1</cfif>,
					<cfif isdefined("form.RHHpesoJefe") and len(trim(form.RHHpesoJefe))>
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpesoJefe#">
					<cfelse>1</cfif>,
					<cfif isdefined("form.ubicacionB") and len(trim(form.ubicacionB))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacionB#"><cfelse>null</cfif> 
					,<cfif isdefined("form.PCid") and len(trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif> 
					)
		</cfquery>			
	</cfif>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>	
<!--- ELIMINA LA INFORMACION DEL CUARTO TAB (CONOCIMIENTO)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'ELIMINARCONOCIMIENTO'>
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>		
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="RHHabPuestoDelete" datasource="#session.DSN#">
		delete from RHConocimientoPuestoP 
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and RHCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid_2#">
	</cfquery>	
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>	
<!--- MODIFICAR LA INFORMACION DEL CUARTO TAB (CONOCIMIENTO)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'MODIFICARCONOCIMIENTO'>
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
		 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
		 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>		
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="RHHAbPuestoUpdate" datasource="#session.DSN#">
		update RHConocimientoPuestoP
		set RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">, 
			RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">, 
			RHCtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCtipo#">, 
			RHCnotamin = <cfif len(trim(form.RHCnotamin)) >
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHCnotamin/100#">
						<cfelse>null</cfif>,
			RHCpeso = <cfif isdefined("form.RHCpeso") and len(trim(form.RHCpeso)) >
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHCpeso#">
						<cfelse>1</cfif>,
						
			<cfif isdefined ('form.PCid') and len(trim(form.PCid)) gt 0>			
				PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
			</cfif>
			
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
		and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid_2#">
	</cfquery>	
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>	
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="RHCid" type="hidden" value="#form.RHCid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>
<!--- AGREGAR LA INFORMACION DEL CUARTO TAB (CONOCIMIENTO)--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'AGREGARCONOCIMIENTO'>
	<cfquery name="existe" datasource="#session.DSN#">
		select count(RHCid) as registros 
		from RHConocimientoPuestoP a
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> 
		and a.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>
	<cfif existe.registros NEQ 0>	
		<cfset Request.Error.Backs = 1>
		<cf_throw message="La habilidad ya ha sido asignado al puesto" errorcode="5020">
	<cfelse>
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHDescripPuestoP
			set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			BMusumod     	    = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			BMfechamod		    = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
				 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			</cfif>			
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>		
		<cfquery name="RHHabPuestoInsert" datasource="#session.DSN#">
			insert into RHConocimientoPuestoP (RHDPPid,RHCid,RHNid,RHCnotamin,RHCtipo,RHCpeso,PCid,BMUsucodigo)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">,
					<cfif len(trim(form.RHCnotamin))>
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHCnotamin/100#">
					<cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCtipo#">,
					<cfif isdefined("form.RHCpeso") and len(trim(form.RHCpeso)) >
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHCpeso#">
					<cfelse>1</cfif>,
					<cfif isdefined ('form.PCid') and len(trim(form.PCid)) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
		</cfquery>			
	</cfif>
	<cfoutput>
		<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

			<cfparam name="action" default="PerfilPuesto.cfm">
		<cfelse>
			<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
		</cfif>
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>	
<!--- AGREGAR LA INFORMACION DEL QUINTO TAB (VALORES)--->
<cfelseif IsDefined("form.Boton")and form.Boton eq 'AGREGARVALORES'>
	<cfquery name="RHValPuestoDel" datasource="#session.DSN#">
		delete from RHValorPuestoP
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
	</cfquery>	
	<cfquery name="rsupdate" datasource="#session.DSN#">
		update RHDescripPuestoP
		set  Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
			 BMusumod     	= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
			 BMfechamod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		
		<cfif form.USUARIO eq 'ASESOR'  OR  form.USUARIO eq 'ASESORM'>
			 ,UsuarioAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
			 ,FechaModAsesor	= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		</cfif>			
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined("form.RHCGidList") and len(trim(form.RHCGidList)) gt 0>
		<cfset arrayKeys = ListToArray(form.RHCGidList)>
		<cfloop from="1" to="#ArrayLen(arrayKeys)#" index="i">
			<cfset datos = ListToArray(arrayKeys[i],'|')>
			<cfquery name="RHValPuestoConsulta" datasource="#session.DSN#">
				select 1
				from RHValorPuestoP
				where RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
				  and RHECGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
				  and RHDCGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
			</cfquery>
			<cfif isdefined("RHValPuestoConsulta") and RHValPuestoConsulta.RecordCount Eq 0>
				<cfquery name="RHValPuestoInsert" datasource="#session.DSN#">
					insert into RHValorPuestoP
					(RHDPPid, RHECGid, RHDCGid,RHVPtipo)
					values(<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">,
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">,
						   <cfif datos[3] neq '00'>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[3]#">
						   <cfelse>
							null
						   </cfif>)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfoutput>
	<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORSP'>

		<cfparam name="action" default="PerfilPuesto.cfm">
	<cfelse>
		<cfparam name="action" default="ApruebaPerfilPuesto.cfm">
	</cfif>
		<form action="#action#" method="post" name="sql">
			<input name="sel"    type="hidden" value="#form.sel#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="USUARIO" type="hidden" value="#form.USUARIO#">
		</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>		
<!--- APROBACIONFINAL--->	
<cfelseif IsDefined("form.Boton")and form.Boton eq 'APROBACIONFINAL'>	
	<cfquery name="rsRHDescripPuestoP" datasource="#session.DSN#">
		select RHDPmision,RHDPobjetivos,RHPcodigo  from  RHDescripPuestoP
		where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	

	<cfquery name="RSJEFEASESOR" datasource="#session.DSN#">
		select ltrim(rtrim(Pvalor)) as CFID  
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 700				
	</cfquery>
	<cfset EL_PUESTO_ES_DEL_JEFEASESOR = true>
	<cfif RSJEFEASESOR.recordCount GT 0>
		<cfquery name="RSCFPUESTO" datasource="#session.DSN#">
			select coalesce (CFid ,-1) as CFid   from RHPuestos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'
		</cfquery>
		<cfif RSJEFEASESOR.CFID eq RSCFPUESTO.CFID>
			<cfset EL_PUESTO_ES_DEL_JEFEASESOR = true>
		<cfelse>
			<cfset EL_PUESTO_ES_DEL_JEFEASESOR = false>
		</cfif>	
	<cfelse>
		<cfset EL_PUESTO_ES_DEL_JEFEASESOR = false>
	</cfif>	
	<cftransaction>
		<!--- PASO 1 Actualiza mision y responsabilidad --->
		<cfif rsRHDescripPuestoP.recordCount GT 0>
			<cfquery name="rsvalidaDes" datasource="#session.DSN#">
				select RHPcodigo from  RHDescriptivoPuesto
				where RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsvalidaDes.recordCount GT 0>
				<cfquery name="rsupdate" datasource="#session.DSN#">
					update RHDescriptivoPuesto
					set   RHDPmision 		= <cfqueryparam value="#rsRHDescripPuestoP.RHDPmision#" 	cfsqltype="cf_sql_longvarchar">,
						  RHDPobjetivos 	= <cfqueryparam value="#rsRHDescripPuestoP.RHDPobjetivos#"  cfsqltype="cf_sql_longvarchar">,
						  BMfecha      		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						  BMusumod     		= <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
					where RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			<cfelse>
				<cfquery name="rsupdate" datasource="#session.DSN#">
					insert into RHDescriptivoPuesto 
					(RHPcodigo, Ecodigo, BMusuario, BMfecha, BMusumod, BMfechamod, RHDPmision, RHDPobjetivos, BMUsucodigo)
					values (
					 '#rsRHDescripPuestoP.RHPcodigo#',
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					 <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,	
					 <cfqueryparam value="#rsRHDescripPuestoP.RHDPmision#" 	cfsqltype="cf_sql_longvarchar">,
					 <cfqueryparam value="#rsRHDescripPuestoP.RHDPobjetivos#"  cfsqltype="cf_sql_longvarchar">,	
					 	<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">	
					)
				</cfquery>
		  </cfif>		
			
			
		</cfif>
		
		<!--- PASO 2. datos variables --->
		<cfquery name="RSBuscaDatosVariables" datasource="#session.DSN#">
			select 
				RHEDVid,
				RHDDVlinea,
				RHDDVvalor,
				RHDVPorden,
				BMUsucodigo
			from RHDVPuestoP
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		</cfquery>
		<cfif RSBuscaDatosVariables.recordCount GT 0>
			<cfloop query="RSBuscaDatosVariables">
				<cfquery name="RSBuscar" datasource="#session.DSN#">
					select RHEDVid from RHDVPuesto
					where RHEDVid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaDatosVariables.RHEDVid#">
					and RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaDatosVariables.RHDDVlinea#">
					and RHPcodigo  = '#rsRHDescripPuestoP.RHPcodigo#'
					and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif RSBuscar.recordCount GT 0>
					<!--- PASO 2.A ACTUALIZA --->
					<cfquery name="RSinsertadatos" datasource="#session.DSN#">
						update RHDVPuesto set 
							RHDDVvalor  = <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#RSBuscaDatosVariables.RHDDVvalor#">,
							RHDVPorden  = <cfif len(trim(RSBuscaDatosVariables.RHDVPorden))><cfqueryparam value="#RSBuscaDatosVariables.RHDVPorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
							BMUsucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
						where RHEDVid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaDatosVariables.RHEDVid#">
						and RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaDatosVariables.RHDDVlinea#">
						and RHPcodigo  = '#rsRHDescripPuestoP.RHPcodigo#'
						and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
				<cfelse>
					<!--- PASO 2.B INSERTA --->
					
					<cfquery name="RSinsertadatos" datasource="#session.DSN#">
						insert into RHDVPuesto (
							Ecodigo,
							RHPcodigo,
							RHEDVid,
							RHDDVlinea,
							fechaalta,
							RHDDVvalor,
							RHDVPorden,
							BMUsucodigo
						)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">,
							'#rsRHDescripPuestoP.RHPcodigo#',
							<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#RSBuscaDatosVariables.RHEDVid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric"   		value="#RSBuscaDatosVariables.RHDDVlinea#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 		value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#RSBuscaDatosVariables.RHDDVvalor#">,
							<cfif len(trim(RSBuscaDatosVariables.RHDVPorden))><cfqueryparam value="#RSBuscaDatosVariables.RHDVPorden#" cfsqltype="cf_sql_integer"><cfelse>null</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric"    	value="#session.usucodigo#">
						) 
					</cfquery>	
				</cfif>
			</cfloop>	
		</cfif>
		<!--- PASO 2.C Borrar --->
		<cfquery name="RSborrarDV" datasource="#session.DSN#">
			delete from RHDVPuesto 
			where not exists ( select 1 from RHDVPuestoP 
							where  RHDVPuesto.RHEDVid = RHDVPuestoP.RHEDVid 
							and    RHDVPuesto.RHEDVid = RHDVPuestoP.RHEDVid
							and    RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
							)
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
			and RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'				
		</cfquery>
		<!--- PASO 3. habilidades --->

		<cfquery name="RSBuscaHabilidad" datasource="#session.DSN#">
			select RHHid,RHNid,RHNnotamin,RHHtipo,RHHpeso,RHHpesoJefe,PCid,ubicacionB,BMUsucodigo
			from RHHabilidadPuestoP
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		</cfquery>
		
		<cfif RSBuscaHabilidad.recordCount GT 0>
			<cfloop query="RSBuscaHabilidad">
				<cfquery name="RSBuscar" datasource="#session.DSN#">
					select RHHid from RHHabilidadesPuesto
					where RHHid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.RHHid#">
					and RHPcodigo  = '#rsRHDescripPuestoP.RHPcodigo#'
					and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif RSBuscar.recordCount GT 0>
					<!--- PASO 3.A ACTUALIZA --->
					<cfquery name="RSinsertadatos" datasource="#session.DSN#">
						update RHHabilidadesPuesto set 
							RHNid   	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#RSBuscaHabilidad.RHNid#">,
							RHHtipo  	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#RSBuscaHabilidad.RHHtipo#">,
							<cfif len(trim(RSBuscaHabilidad.RHNnotamin)) >
								RHNnotamin  =<cfqueryparam cfsqltype="cf_sql_float" 	value="#RSBuscaHabilidad.RHNnotamin#">
							<cfelse>RHNnotamin  = null</cfif>, 
							<cfif isdefined("RSBuscaHabilidad.RHHpeso") and len(trim(RSBuscaHabilidad.RHHpeso))>
								RHHpeso  	= <cfqueryparam cfsqltype="cf_sql_money" value="#RSBuscaHabilidad.RHHpeso#">
							<cfelse>RHHpeso  	= 1</cfif>,
							<cfif isdefined("RSBuscaHabilidad.RHHpesoJefe") and len(trim(RSBuscaHabilidad.RHHpesoJefe))>
								RHHpesoJefe  	= <cfqueryparam cfsqltype="cf_sql_money" value="#RSBuscaHabilidad.RHHpesoJefe#">
							<cfelse>RHHpesoJefe  	= 1</cfif>,
							ubicacionB  = <cfif isdefined("RSBuscaHabilidad.ubicacionB") and len(trim(RSBuscaHabilidad.ubicacionB))><cfqueryparam cfsqltype="cf_sql_varchar" value="#RSBuscaHabilidad.ubicacionB#"><cfelse>null</cfif>,
							PCid  		= <cfif isdefined("RSBuscaHabilidad.PCid") and len(trim(RSBuscaHabilidad.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.PCid#"><cfelse>null</cfif> ,
							BMUsucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">					
						where RHHid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.RHHid#">
						and RHPcodigo  = '#rsRHDescripPuestoP.RHPcodigo#'
						and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>					
				<cfelse>
					<!--- PASO 3.B INSERTA --->
					<cfquery name="RSinsertadatos" datasource="#session.DSN#">
						insert into RHHabilidadesPuesto(RHPcodigo, Ecodigo, RHHid, RHNid, RHHtipo, RHNnotamin, RHHpeso,RHHpesoJefe, ubicacionB, PCid,BMUsucodigo)
						values( '#rsRHDescripPuestoP.RHPcodigo#',
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.RHHid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.RHNid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.RHHtipo#">,
								<cfif len(trim(RSBuscaHabilidad.RHNnotamin)) >
									<cfqueryparam cfsqltype="cf_sql_float" 	value="#RSBuscaHabilidad.RHNnotamin#">
								<cfelse>null</cfif>, 
								<cfif isdefined("RSBuscaHabilidad.RHHpeso") and len(trim(RSBuscaHabilidad.RHHpeso))>
									<cfqueryparam cfsqltype="cf_sql_money" value="#RSBuscaHabilidad.RHHpeso#">
								<cfelse>1</cfif>,
								<cfif isdefined("RSBuscaHabilidad.RHHpesoJefe") and len(trim(RSBuscaHabilidad.RHHpesoJefe))>
									<cfqueryparam cfsqltype="cf_sql_money" value="#RSBuscaHabilidad.RHHpesoJefe#">
								<cfelse>1</cfif>,
								<cfif isdefined("RSBuscaHabilidad.ubicacionB") and len(trim(RSBuscaHabilidad.ubicacionB))><cfqueryparam cfsqltype="cf_sql_varchar" value="#RSBuscaHabilidad.ubicacionB#"><cfelse>null</cfif>,
								<cfif isdefined("RSBuscaHabilidad.PCid") and len(trim(RSBuscaHabilidad.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaHabilidad.PCid#"><cfelse>null</cfif>,
								<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric"> 
						)
					</cfquery>
				</cfif>	
			</cfloop>
		</cfif>	

		<!--- PASO 3.C Borrar --->
		<cfquery name="RSborrarHabilidades" datasource="#session.DSN#">
			delete from RHHabilidadesPuesto 
			where not exists ( select 1 from RHHabilidadPuestoP 
							where  RHHabilidadesPuesto.RHHid = RHHabilidadPuestoP.RHHid 
							and    RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
							)
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
			and RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'				
		</cfquery>

		<!--- queda pendiente el considerar si se borra una habilidad con dependencias. --->
		
		<!--- PASO 4 conocimientos --->
		<cfquery name="RSBuscaConocimiento" datasource="#session.DSN#">
			select RHCid,RHNid,RHCnotamin,RHCtipo,RHCpeso,BMUsucodigo,PCid
			from RHConocimientoPuestoP
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		</cfquery>

		<cfif RSBuscaConocimiento.recordCount GT 0>
			<cfloop query="RSBuscaConocimiento">
				<cfquery name="RSBuscar" datasource="#session.DSN#">
					select RHCid from RHConocimientosPuesto
					where RHCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHCid#">
					and RHPcodigo  = '#rsRHDescripPuestoP.RHPcodigo#'
					and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfif RSBuscar.recordCount GT 0>

					<!--- PASO 4.A ACTUALIZA --->
					<cfquery name="RSinsertadatos" datasource="#session.DSN#">
						update RHConocimientosPuesto
						set RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHCid#">, 
							RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHNid#">, 
							RHCtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHCtipo#">, 
							RHCnotamin = <cfif len(trim(RSBuscaConocimiento.RHCnotamin)) >
											<cfqueryparam cfsqltype="cf_sql_float" value="#RSBuscaConocimiento.RHCnotamin#">
										<cfelse>null</cfif>,
							RHCpeso = <cfif isdefined("RSBuscaConocimiento.RHCpeso") and len(trim(RSBuscaConocimiento.RHCpeso)) >
											<cfqueryparam cfsqltype="cf_sql_money" value="#RSBuscaConocimiento.RHCpeso#">
										<cfelse>1</cfif>
							<cfif isdefined('RSBuscaConocimiento.PCid') and len(trim(RSBuscaConocimiento.PCid))>
							,PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.PCid#">
							</cfif>
							,BMUsucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">		
						where RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHCid#">
						  
						  
						  
					</cfquery>					
				<cfelse>
					<!--- PASO 4.B INSERTA --->
					<cftry>
						<cfquery name="RHConPuestoInsert" datasource="#session.DSN#">
							insert into RHConocimientosPuesto(RHPcodigo, Ecodigo, RHCid, RHNid, RHCtipo, RHCnotamin, RHCpeso,PCid,BMUsucodigo )
							values( '#rsRHDescripPuestoP.RHPcodigo#',
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHCid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHNid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.RHCtipo#">,
								<cfif len(trim(RSBuscaConocimiento.RHCnotamin))>
									<cfqueryparam cfsqltype="cf_sql_float" value="#RSBuscaConocimiento.RHCnotamin#">
								<cfelse>null</cfif>,
								<cfif isdefined("RSBuscaConocimiento.RHCpeso") and len(trim(RSBuscaConocimiento.RHCpeso)) >
									<cfqueryparam cfsqltype="cf_sql_money" value="#RSBuscaConocimiento.RHCpeso#">
								<cfelse>1</cfif>,
								<cfif isdefined('RSBuscaConocimiento.PCid') and len(trim(RSBuscaConocimiento.PCid))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#RSBuscaConocimiento.PCid#">,
								<cfelse>
									null,
								</cfif>
								<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric"> )
						</cfquery>
					<cfcatch>
						<cfthrow message="ERROR: favor contactar al proveedor.">
						<cfabort>
					</cfcatch>
					</cftry>	
				</cfif>	
			</cfloop>
		</cfif>
		<!--- PASO 4.C Borrar --->
		<cfquery name="RSborrarHabilidades" datasource="#session.DSN#">
			delete from RHConocimientosPuesto 
			where not exists ( select 1 from RHConocimientoPuestoP 
							where  RHConocimientosPuesto.RHCid = RHConocimientoPuestoP.RHCid 
							and    RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
							)
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
			and RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'				
		</cfquery>	
		<!--- queda pendiente el considerar si se borra un conocimiento con dependencias. --->
		
		<!--- PASO 5 valores--->
		<cfquery name="RHValPuestoDel" datasource="#session.DSN#">
			delete from RHValoresPuesto
			where RHPcodigo = '#rsRHDescripPuestoP.RHPcodigo#'
			 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
		
		<cfquery name="RHValPuestoInsert" datasource="#session.DSN#">
			insert into RHValoresPuesto
			(RHPcodigo, Ecodigo, RHECGid, RHDCGid,RHVPtipo,BMUsucodigo)
			select 
			'#rsRHDescripPuestoP.RHPcodigo#', 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			RHECGid,
			RHDCGid,
			RHVPtipo,
			<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric"> as BMUsucodigo
			from RHValorPuestoP
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#"> 
		</cfquery>
		<!--- PASO 6 Actualiza el ultimo usuario que modifico el perfil y la fecha --->
		<cfquery name="rsQuienModifico" datasource="#session.DSN#">
			select BMusumod,BMfechamod  from RHDescripPuestoP
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHPuestos set 
				BMusumod     =  <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsQuienModifico.BMusumod#">,
				BMfechamod   =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsQuienModifico.BMfechamod#" >
			where RHPcodigo  = '#rsRHDescripPuestoP.RHPcodigo#'
			and Ecodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<!--- PASO 7 cambia de estado el perfil--->
		<cfquery name="rsupdate" datasource="#session.DSN#">
			update RHDescripPuestoP
			set  Estado 	    = 50,
				 Observaciones 	= <cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_longvarchar">,
				 UsuarioJefeAsesor  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				 FechaModJefeAsesor = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				 <cfif EL_PUESTO_ES_DEL_JEFEASESOR>
					 UsuarioJefeCF  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 FechaModJefeCF = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				 </cfif>
				 BMusumod  = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			where RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cftransaction>
	<cfquery name="RSPara" datasource="#session.DSN#">
		select a.UsuarioAsesor,{fn concat(a.RHPcodigo,{fn concat(' ' ,b.RHPdescpuesto)})} Puesto
		from RHDescripPuestoP a
		inner join RHPuestos b
		on a.RHPcodigo  = b.RHPcodigo 
		and a.Ecodigo  = b.Ecodigo
		where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfset EmailDE = "">
	<cfset EmailPARA = "">
	<cfset NombreDE = "">
	<cfset NombrePARA = "">

	<cfif RSPara.recordCount GT 0>
		
		<!--- Busca el correo del ASESOR  --->
		<cfquery name="RSPARAEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPara.UsuarioAsesor#">
		</cfquery>
		<cfif RSPARAEmpleado.recordCount GT 0 and  len(trim(RSPARAEmpleado.llave))>
			<cfquery name="RSparacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSPARAEmpleado.llave#">
			</cfquery>
			<cfif RSparacorreo.recordCount GT 0>
				<cfset EmailPARA = RSparacorreo.DEemail>
				<cfset NombrePARA = RSparacorreo.nombre>
			</cfif>
		</cfif>
		<!--- Busca el correo del  JEFE ASESOR  --->
		<cfquery name="RSenviaEmpleado" datasource="#session.DSN#">
			select llave 
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			and STabla = 'DatosEmpleado'
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
		<cfif RSenviaEmpleado.recordCount GT 0 and len(trim(RSenviaEmpleado.llave))>
			<cfquery name="RSenviacorreo" datasource="#session.DSN#">
				select DEemail, 			
				{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
				 from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RSenviaEmpleado.llave#">
			</cfquery>
			<cfif RSenviacorreo.recordCount GT 0>
				<cfset EmailDE = RSenviacorreo.DEemail>
				<cfset NombreDE = RSenviacorreo.nombre>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("EmailPARA") and len(trim(EmailPARA)) and isdefined("EmailDE") and len(trim(EmailDE))>
		<cfinclude template="rechazo-correo.cfm">

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Informacion_sobre_el_perfil_de_puesto_creado"
			Default="Informaci&oacute;n sobre el perfil de puesto creado"
			returnvariable="MSG_Informacion_sobre_el_perfil_de_puesto_creado"/>
			
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_El_perfil_del_puesto"
			Default="El perfil del puesto"
			returnvariable="MSG_El_perfil_del_puesto"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_fue_Aprobado"
			Default="fue aprobado"
			returnvariable="MSG_fue_Aprobado"/>	
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Jefe_de_Asesores"
			Default="Jefe de Asesores"
			returnvariable="MSG_Jefe_de_Asesores"/>	
		<cfset motivo = MSG_El_perfil_del_puesto &'  ' & RSPara.Puesto &'  <b><font color="blue"> ' & MSG_fue_Aprobado & '</font></b> '  >


		<cfset NombreDE = NombreDE & '  ' & MSG_Jefe_de_Asesores >

		<cfset _mailBody  = mailBody(NombreDE,NombrePARA,motivo)>
		
		
		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailDE#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#EmailPARA#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSG_Informacion_sobre_el_perfil_de_puesto_creado2#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mailBody#">, 1)
		</cfquery>
	</cfif>	
	
		<cfparam name="action" default="ApruebaPuestos-lista.cfm">
		<cflocation url="#action#">
		<!--- <form action="#action#" method="post" name="sql">
		</form>
	<cfoutput></cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML> --->
</cfif>

