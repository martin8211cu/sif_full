<cfcomponent>
	<!---==================AGREGA UN NUEVO EVENTO==================--->
	<cffunction name="ALTA_EVENTO"   access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 		  type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="TEVid"       	  type="numeric" required="true">
		<cfargument name="CEVidTabla"  	  type="numeric" required="true">
		<cfargument name="CEVDescripcion" type="string"  required="true">
		<cfargument name="FechaEvento"    type="date"    required="true">
		<cfargument name="HoraEvento"     type="numeric" required="false" default="-1">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		
		<cfif #Arguments.HoraEvento# EQ -1><cfset Arguments.HoraEvento = "null"></cfif>
	
		<cfquery datasource="#Arguments.Conexion#" name="rsControlEventos">
			insert into ControlEvento (
				Ecodigo, TEVid , CEVidTabla, CEVDescripcion, FechaEvento, HoraEvento, BMUsucodigo )
			values(
				#Arguments.Ecodigo#,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.TEVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CEVidTabla#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" 	value="#TRIM(Arguments.CEVDescripcion)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.FechaEvento#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.HoraEvento#">,
				 #Arguments.BMUsucodigo#
			   )
			   <cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsControlEventos">
			  <cfreturn #rsControlEventos.identity#>
	</cffunction>
	<!---========AGREGA UNA NUEVA LINEA AL SEGUIMIENTO DE ESTADOS DEL EVENTO===========--->
	<cffunction name="ALTA_SEGUIMIENTO"   access="public">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid"       	  type="numeric" required="true">
		<cfargument name="TEVECodigo"  	  type="numeric" required="false" default="-1">
		<cfargument name="SEVDescripcion" type="string"  required="true">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">	
					

		<cfif Arguments.TEVECodigo EQ -1>
			<cfquery datasource="#Arguments.Conexion#" name="rsTEVECodigo">
				select 
					   Coalesce(
						(select min(TEVECodigo) from TipoEventoEstado a where a.TEVEdefault = 1 and a.TEVid = b.TEVid),
						(select min(TEVECodigo) from TipoEventoEstado a where a.TEVid = b.TEVid)
						) as valor
				from ControlEvento b
				 where CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CEVid#">
			</cfquery>			
			<cfif rsTEVECodigo.recordCount GT 0>
				<cfset Arguments.TEVECodigo = rsTEVECodigo.valor> 
			<cfelse>
				<cfthrow message="El Tipo de Evento no posee estados Definidos">
			</cfif>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#" name="rsTEVECodigo">
				select Count(1) cantidad
				from ControlEvento a
					inner join TipoEventoEstado b
						on a.TEVid = b.TEVid
				 where a.CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CEVid#">
				   and b.TEVECodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.TEVECodigo#">
			</cfquery>
			<cfif rsTEVECodigo.cantidad EQ 0>
				<cfthrow message="El código del estado enviado no existe">
			</cfif>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsControlEventos">
			insert into SeguimientoEvento 
				(SEVid,CEVid,TEVECodigo,SEVDescripcion,FechaAlta, BMUsucodigo)
			select
				Coalesce(max(SEVid)+1,0),
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CEVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.TEVECodigo#">,				
				<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" 	value="#TRIM(Arguments.SEVDescripcion)#">,
				<cf_dbfunction name="now">,
				 #Arguments.BMUsucodigo#
			   from SeguimientoEvento 
			 where CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CEVid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#" name="seguimiento">
			select max(SEVid) SEVid from SeguimientoEvento  where CEVid = #Arguments.CEVid#
		</cfquery>
		
		<cfinvoke component="sif.Componentes.ControlEventos" method="MAIL_NOTIFICA">
			<cfinvokeargument name="CEVid" 			value="#Arguments.CEVid#">
			<cfinvokeargument name="SEVid" 			value="#seguimiento.SEVid#">
		</cfinvoke>
		
	</cffunction>
	<!---========AGREGA UN RESPONSABLE MAS PARA UN EVENTO===========--->
	<cffunction name="ALTA_RESPONSABLE"   access="public">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid"       	  type="numeric" required="true">
		<cfargument name="DEid"  	  	  type="numeric" required="true">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
	
		<cfquery datasource="#Arguments.Conexion#" name="rsControlEventos">
			insert into ResponsableEvento 
				(CEVid, DEid, BMUsucodigo)
			values(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CEVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DEid#">,
				 #Arguments.BMUsucodigo#
			    )
		</cfquery>
	</cffunction>
	<!---==================MODIFICAR UN EVENTO==================--->
	<cffunction name="CAMBIO_EVENTO" access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVDescripcion" type="string"  required="true">
		<cfargument name="FechaEvento"    type="date"    required="true">
		<cfargument name="HoraEvento"     type="numeric" required="false" default="-1">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="CEVid"    	  type="numeric" required="true">
		
		<cfif #Arguments.HoraEvento# EQ -1><cfset Arguments.HoraEvento = "null"></cfif>
		
		<cfquery datasource="#Arguments.Conexion#">	
			update ControlEvento set 
			   CEVDescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" 	value="#TRIM(Arguments.CEVDescripcion)#">,
			   FechaEvento 	  = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.FechaEvento#">,
			   HoraEvento     = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.HoraEvento#">,
			   BMUsucodigo	  = #Arguments.BMUsucodigo#
		  where CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEVid#">
		</cfquery>
		
	</cffunction>
	<!---==================ELIMINAR UN EVENTO==================--->
	<cffunction name="BAJA_EVENTO"  access="public" returntype="string">
		<cfargument name="Conexion" 	type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid" 		type="numeric" required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from ControlEvento 
			where CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEVid#">
		</cfquery>
	</cffunction>
	<!---==================ELIMINAR UN RESPONSABLES==================--->
	<cffunction name="BAJA_RESPONSABLE"  access="public" returntype="string">
		<cfargument name="Conexion" 	type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid" 		type="numeric" required="true">
		<cfargument name="DEid" 		type="numeric" required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from ResponsableEvento 
			where CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEVid#">
			  and DEid  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
	</cffunction>
	<!---==================OBTIENEN LA INFORMACION DE UN EVENTO==================--->
	<cffunction name="GET_EVENTO"   access="public" returntype="query">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid" 		  type="numeric" required="false" default="-1">
	
		<cfquery datasource="#Arguments.Conexion#" name="rsControlEventos">
			select ce.CEVid,ce.Ecodigo, ce.TEVid , ce.CEVidTabla, ce.CEVDescripcion, ce.FechaEvento, ce.HoraEvento, ce.BMUsucodigo, te.TEVDescripcion
			from ControlEvento ce
				inner join TipoEvento te
					on ce.TEVid = te.TEVid
		 <cfif CEVid NEQ -1>
			 where CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEVid#">
		</cfif>
		</cfquery>
		<cfreturn rsControlEventos>
	</cffunction>
	<!---==================OBTIENEN TODOS LOS ESTADOS DE UN TIPO DE EVENTO==================--->
	<cffunction name="GET_ESTADOS"   access="public" returntype="query">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="TEVid" 		  type="numeric" required="true">
		<cfargument name="TEVECodigo" 	  type="numeric" required="false" default="-1">
		
		<cfset checked   = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
		<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>">
		<cfset Notifica  = "<img border=0 src=/cfmx/sif/imagenes/E-Mail-Link.gif>">

		<cfquery datasource="#Arguments.Conexion#" name="rsEstadosEventos">
			select TEVid,TEVECodigo,TEVEDescripcion,TEVEdefault,TEVENotifica,
			case when TEVEdefault = 0 then '#unchecked#' else '#checked#' end as TEVEdefaultlabel,
			case when TEVENotifica = 0 then '' else '#Notifica#' end as TEVENotificalabel  
			 from TipoEventoEstado 
			where TEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#"> 
			<cfif Arguments.TEVECodigo NEQ -1>
				and TEVECodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVECodigo#">
			</cfif>
		</cfquery>
		<cfreturn rsEstadosEventos>
	</cffunction>
	<!---==================OBTIENEN TODOS LOS SEGUIMIENTOS DE UN EVENTO==================--->
	<cffunction name="GET_SEGUIMIENTO"   access="public" returntype="query">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid" 		  type="numeric" required="true">
		
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
			
		<cfquery datasource="#Arguments.Conexion#" name="rsSeguiEventos">
			select a.SEVid,a.CEVid,a.TEVECodigo,c.TEVEDescripcion,a.FechaAlta,
			a.SEVDescripcion #_Cat# '&nbsp;&nbsp;' justificacion,
			e.Pnombre #_Cat# ' '#_Cat#Papellido1 #_Cat# ' '#_Cat# Papellido2 #_Cat# '&nbsp;&nbsp;' as Usuario
			 from SeguimientoEvento a
			 	inner join ControlEvento b
					on a.CEVid = b.CEVid 
			 	inner join TipoEventoEstado c
					on c.TEVid = b.TEVid
					and c.TEVECodigo = a.TEVECodigo
				left outer join Usuario d
					left outer join DatosPersonales e
						on d.datos_personales = e.datos_personales
					on d.Usucodigo = a.BMUsucodigo
							
			where a.CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEVid#"> 
		</cfquery>
		<cfreturn rsSeguiEventos>
	</cffunction>
	<!---================OBTIENE TODOS LOS RESPONSABLES PARA UN EVENTO--->	
	<cffunction name="GET_RESPONSABLE"   access="public" returntype="query">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid" 		  type="numeric" required="true">
		<cfargument name="FunctionDelete" type="string"  required="false" default="FunctionDelete">
		<cfargument name="CEVidName"	  type="string"  required="false" default="CEVid">
		<cfargument name="DEidName"	  	  type="string"  required="false" default="DEid">
		
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfset borrar 	 = "<input name=''imageField'' type=''image'' src=''../../imagenes/Borrar01_S.gif' width=''16'' height=''16'' border=''0'' onclick=''javascript:#Arguments.FunctionDelete#();''>">
			
		<cfquery datasource="#Arguments.Conexion#" name="rsRespoEventos">
			select a.CEVid as #Arguments.CEVidName#, 
			       a.DEid  as #Arguments.DEidName#,
				b.DEnombre #_Cat# ' '#_Cat# b.DEapellido1 #_Cat# ' '#_Cat# b.DEapellido2 #_Cat# '&nbsp;&nbsp;' as Empleado,
			'#borrar#' as Borrar 
			 from ResponsableEvento a
			 	inner join DatosEmpleado b
					on a.DEid = b.DEid
			where a.CEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CEVid#"> 
		</cfquery>
		<cfreturn rsRespoEventos>
	</cffunction>
	<!---================ENVIA CORREO A LOS REPONSABLES==========--->	
	<cffunction name="MAIL_NOTIFICA"   access="public" >
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="CEVid" 	  	  type="numeric"  required="true">
		<cfargument name="SEVid" 	  	  type="numeric"  required="true">
		
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		<!---Este correo quedaría fijo para Activos Fijos por lo urgencia, si en alguno momentos se implementa para otro modulo hay que cambiar el cfsavecontent--->
		<cfquery datasource="#Arguments.Conexion#" name="evento">
			select 
			     de.DEemail email,
				 de.DEnombre #_Cat# ' ' #_Cat# de.DEapellido1 #_Cat#' '#_Cat# de.DEapellido2 Empleado,
			     tee.TEVEDescripcion EstadoActual,
				 Coalesce(Atee.TEVEDescripcion,'(Sin Anterior)') EstadoAnterior,
				 te.TEVDescripcion tipoEvento, 
				 se.SEVDescripcion justificacion ,
				 ce.CEVDescripcion nombre,
				 act.Aplaca #_Cat# '-' #_Cat# act.Adescripcion Activo,
				 case when afde.DEid is not null then 
				 	afde.DEnombre #_Cat# ' ' #_Cat# afde.DEapellido1 #_Cat#' '#_Cat# afde.DEapellido2 
				else '-Sin Responsable-' end as Responsable,
				cate.ACcodigodesc #_Cat# '-' #_Cat# cate.ACdescripcion #_Cat# '/' #_Cat# cla.ACcodigodesc #_Cat# cla.ACdescripcion  Categoriaclase
				 
			  from ControlEvento ce
			  
			  	inner join SeguimientoEvento se
					 on se.CEVid = ce.CEVid
			  	    and se.SEVid = #Arguments.SEVid#
				
				inner join TipoEventoEstado tee
					on tee.TEVid      = ce.TEVid
				   	and tee.TEVECodigo = se.TEVECodigo
					
				left outer join SeguimientoEvento Ase
					on Ase.CEVid = ce.CEVid
			  	   and Ase.SEVid = (#Arguments.SEVid#-1)
						
				left outer join TipoEventoEstado Atee
					on Atee.TEVid      = ce.TEVid
				   and Atee.TEVECodigo = Ase.TEVECodigo
					
			    inner join ResponsableEvento re
					 on re.CEVid = ce.CEVid  
					 
				inner join DatosEmpleado de
					on de.DEid = re.DEid
				   
				 inner join TipoEvento te
					on te.TEVid = ce.TEVid  
					
				inner join Activos act
					on act.Aid = ce.CEVidTabla
					
				left outer join AFResponsables afr
					inner join DatosEmpleado afde
						on afr.DEid = afde.DEid 
					on act.Aid = afr.Aid 
				   and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
				   
				inner join ACategoria cate
					on cate.Ecodigo = act.Ecodigo
					and cate.ACcodigo = act.ACcodigo
					
				inner join AClasificacion cla
					on cla.Ecodigo = act.Ecodigo
					and cla.ACcodigo = act.ACcodigo
					and cla.ACid = act.ACid	

				 where ce.CEVid 		= #Arguments.CEVid#
				   and tee.TEVENotifica = 1
				   and de.DEemail is not null
		</cfquery>
		
		<cfloop query="evento">
			
			<cfsavecontent variable="_mail_body">
				<cfset args = StructNew()>
				<cfset modulo 		  		 = 'Sistema de Control de Activos'>
				<cfset args.titulo 	  		 = 'Información sobre Eventos en el #modulo#'>
				<cfset args.remitente 		 = '#modulo#'>
				<cfset args.datos_personales = evento.Empleado>
				<cfset args.titulo2  		 = 'Información sobre Comentarios del Evento de #evento.nombre#'>
				<cfset args.info		 	 = 'El '&evento.tipoEvento&' se Cambio del estado '& evento.EstadoAnterior &' al nuevo estado '&evento.EstadoActual>
				<cfset args.Activo 			 = evento.Activo>
				<cfset args.Responsable		 = evento.Responsable>
				<cfset args.CategoriaClase	 = evento.Categoriaclase>
				<cfset args.justificacion 	 = evento.justificacion>
				<cfset args.hostname 		 = session.sitio.host>
					
				<cfinclude template="/sif/ad/eventos/mail-notifica.cfm">
				</cfsavecontent>
			<cfquery datasource="#Arguments.Conexion#">
				insert INTO SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
					values ('gestion@soin.co.cr',
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#evento.email#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Control de Eventos: #evento.nombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
			</cfquery>	
		</cfloop>
	</cffunction>
	
	
	<!---==================AGREGA==================--->
	<cffunction name="ALTA_Tipo_Evento"   access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 		  type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="TEVcodigo"       type="string"  required="true">
		<cfargument name="TEVDescripcion"  type="string"  required="true">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		
		
		<cfquery name="rsExisteTipoE" datasource="#session.DSN#">
			select count(1) as cantidad 
			from TipoEvento  
			where TEVcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.TEVcodigo#"> 
		</cfquery>
		
		<cfif len(trim(rsExisteTipoE.cantidad)) EQ 1>
				<cfquery datasource="#Arguments.Conexion#" name="rsTipoEventos">
					insert into TipoEvento (
						Ecodigo,TEVcodigo,TEVDescripcion,BMUsucodigo )
					values(
						#Arguments.Ecodigo#,
						<cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#TRIM(Arguments.TEVcodigo)#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#TRIM(Arguments.TEVDescripcion)#">,
						 #Arguments.BMUsucodigo#
						)
						<cf_dbidentity1>
				</cfquery>
       	  <cf_dbidentity2 datasource="#session.DSN#" name="rsTipoEventos" returnvariable="LvarTipoE" verificar_transaccion= "false">
			<cfset varReturn=#LvarTipoE#>	
			<cfset ALTALISTA_Estado(LvarTipoE,'0','Sin Iniciar',#Arguments.Conexion#,#Arguments.BMUsucodigo#,1)>
			<cfset ALTALISTA_Estado(LvarTipoE,'99','Finalizado',#Arguments.Conexion#,#Arguments.BMUsucodigo#)>
		<cfreturn #varReturn#>
		<cfelse>
			<cf_errorCode	code = "50019" msg = "El código del Registro ya Existe.">
		</cfif>
	</cffunction>
	
	
	<!---==================MODIFICAR==================--->
	<cffunction name="CAMBIO_Tipo_Evento" access="public" returntype="string">
		<cfargument name="Conexion" 	   	type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="TEVid" 		   	type="numeric" required="true">
		<cfargument name="TEVcodigo"     	type="string"  required="true">
		<cfargument name="TEVDescripcion"  	type="string"  required="true">
		<cfargument name="BMUsucodigo"    	type="numeric" required="false" default="#Session.Usucodigo#">

		<cfquery datasource="#Arguments.Conexion#">	
			update TipoEvento set 
				TEVcodigo 	  = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#TRIM(Arguments.TEVcodigo)#">,
				TEVDescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#TRIM(Arguments.TEVDescripcion)#">,
				BMUsucodigo	  = #Arguments.BMUsucodigo#
			where TEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">
		</cfquery>
	</cffunction>
	
	
	
	<!---==================ELIMINAR UN Tipo Evento==================--->
	<cffunction name="BAJA_Tipo_Evento"  access="public" returntype="string">
		<cfargument name="Conexion" 	type="string"  required="false" default="#session.dsn#">
		<cfargument name="TEVid" 		type="numeric" required="true">
       <cfargument name="TEVcodigo" 	type="string" required="true">

           	<cfquery name="rsExisteControl" datasource="#session.DSN#">
				select count(1) as cantidadControl 
				from TipoEvento a
					inner  join  ControlEvento b
						on a.TEVid = b.TEVid
				where a.TEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#"> 
			</cfquery>
			
			<cfif rsExisteControl.cantidadControl NEQ 0>	
			  <cfthrow message="No se puede eliminar el registro. Existen activos fijos relacionados a este tipo de evento!">			
			</cfif>
			<cfquery name="rsExisteE" datasource="#session.DSN#">
				select count(1) as cantidad 
				from TipoEvento a
					inner  join  TipoEventoEstado b
						on a.TEVid = b.TEVid
				where a.TEVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TEVcodigo#">
				and a.TEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#"> 
			</cfquery>
			<cfif rsExisteE.cantidad NEQ 0>
			  <cfthrow message="No se puede eliminar el registro. Verifique que no tenga estados asociados.">
			</cfif>

    		<cfquery name="rsExisteConf" datasource="#session.DSN#">
				select count(1) as cantidadConf 
				from TipoEvento a
					inner  join  DVconfiguracionTipo b
						on a.TEVid = b.TEVid
				where a.TEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#"> 
			</cfquery>
			
			<cfif rsExisteConf.cantidadConf NEQ 0>	
			  <cfthrow message="No se puede eliminar el registro. Verifique que no tenga configurados eventos para el tipo de evento, en la pantalla Configuracion de Datos Variables y Eventos">			
			</cfif>
		
		<cfif rsExisteE.cantidad EQ 0 and rsExisteConf.cantidadConf EQ 0 and rsExisteControl.cantidadControl eq 0>		
            <cfquery datasource="#Arguments.Conexion#">	
			 delete from TipoEventoEstado 
			    where  TEVid      = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">			 
		    </cfquery>		
			<cfquery datasource="#Arguments.Conexion#">	
				delete from TipoEvento 
				where TEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#"> 
				and TEVcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.TEVcodigo#">
			</cfquery>		
		</cfif>
	</cffunction>

	
	
	<!---==================AGREGAR UN VALOR A LA LISTA DE ESTADOS==================--->
	<cffunction name="ALTALISTA_Estado"  access="public" returntype="string">
		<cfargument name="TEVid" 		  	 type="numeric" required="true">
		<cfargument name="TEVECodigo" 	 type="numeric" required="true">
		<cfargument name="TEVEDescripcion"type="string"  required="true">
		<cfargument name="Conexion" 	 	 type="string"  required="false" default="#session.dsn#">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="TEVEdefault"    type="numeric" required="false" default="0">
		<cfargument name="TEVENotifica"   type="numeric" required="false" default="0">
		
		
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select count(1) as cantidad 
			from TipoEventoEstado  
			where TEVECodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVECodigo#"> and 
			TEVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">
		</cfquery>
		
		<cfif len(trim(rsExiste.cantidad)) EQ 1>
		<cfquery datasource="#Arguments.Conexion#">	
			insert into TipoEventoEstado (TEVid,TEVECodigo,TEVEDescripcion,BMUsucodigo,TEVEdefault,TEVENotifica)
			values(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVECodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.TEVEDescripcion)#">,
				#Arguments.BMUsucodigo#,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.TEVEdefault#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.TEVENotifica#">
				)
		</cfquery>
		<cfelse>
			<cf_errorCode	code = "50019" msg = "El código del Registro ya Existe.">
		</cfif>
	</cffunction>
	

	<!---==================BORRAR ==================--->
	<cffunction name="BAJALISTA_Estado"  access="public" returntype="string">
		<cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="TEVid" 		  	 type="numeric" required="true">
		<cfargument name="TEVECodigo" 	 type="numeric" required="true">
		
		<cfquery datasource="#Arguments.Conexion#">	
			delete from TipoEventoEstado 
			where  TEVid      = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">
			   and TEVECodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVECodigo#">
		</cfquery>
	</cffunction>
	
	<!---==================MODIFICAR ==================--->
	<cffunction name="CAMBIOLISTA_Estado"  access="public" returntype="string">
		<cfargument name="Conexion" 	 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="TEVid" 		 	  type="numeric" required="true">
		<cfargument name="TEVECodigo" 	  type="numeric"  required="true">
		<cfargument name="TEVEDescripcion" type="string"  required="true">
		<cfargument name="TEVENotifica" 		type="numeric"  required="false">
		
		<cfquery datasource="#Arguments.Conexion#">	
			update TipoEventoEstado 
			set TEVEDescripcion =  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.TEVEDescripcion)#">,
				 TEVENotifica    =  <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.TEVENotifica#">
			where TEVid         =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVid#">
			and TEVECodigo   	  =  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TEVECodigo#">
		</cfquery>
	</cffunction>
	
	
	
	
	
	
</cfcomponent>