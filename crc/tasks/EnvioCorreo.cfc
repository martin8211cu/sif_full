<cffunction name="envioCorreo" returntype="void">

	<cfargument name="codCorte"  type="string" required="false" default="" />
	<cfargument name="fileCount" type="string" required="false" default="" />
	<cfargument name="Contenido" type="string" required="false" default="" />
	<cfargument name="dsn"       type="string" required="no"    default="#session.dsn#">
    <cfargument name="ecodigo"   type="string" required="no"    default="#session.ecodigo#">
	<cfargument name="plantilla" type="string" required="false" default="" />
	<cfargument name="subject"   type="string" required="false" default="" />
	
	<cfset C_PARAM_ROL_ADM_CREDITO         = '30200711'>
	
	<cfset pRolAdminCredito = ''>
	<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
	<cfset paramInfo = crcParametros.GetParametroInfo(codigo="#C_PARAM_ROL_ADM_CREDITO#",conexion=#arguments.dsn#,ecodigo=#arguments.ecodigo#, descripcion="Rol de administradores de credito" )>
	<cfset emailInfo = crcParametros.GetParametroInfo(codigo="30300109",conexion="#arguments.dsn#",ecodigo=#arguments.ecodigo#,descripcion="Direccion email para envios de correo" )>
	
	<cfif paramInfo.valor neq ''>

		<cfset pRolAdminCredito = paramInfo.valor>
		
		<cfif pRolAdminCredito neq ''>	
			<cfsavecontent variable="_mail_body">
				<cfset _codCorte ="#codCorte#">
				<cfset _fileCount ="#fileCount#">
				<cfset _contenido ="#Contenido#">
				<cfinclude template="../Plantillas/#plantilla#">
			</cfsavecontent>
	
			<cfquery name="rsEmail" datasource="#arguments.dsn#">
			   select dp.Pemail1
			   from  DatosPersonales dp
			   inner join Usuario u
			   on u.datos_personales = dp.datos_personales
			   inner join UsuarioRol ur
			   on ur.Usucodigo = u.Usucodigo
			   where ur.SRcodigo = '#pRolAdminCredito#'   
			</cfquery>
			
			
			<cfloop query = 'rsEmail'>
				
				<cfif rsEmail.Pemail1 neq ''>
					<cfset SMTP = createObject( "component","asp.admin.correo.SMTPQueue")>
					<cfset pdf = SMTP.createEmail(
						   from = "#emailInfo.valor#"
						   , to = #rsEmail.Pemail1#
						   , subject = #subject#
						   , body = #_mail_body# 
						   )>
				</cfif>
			</cfloop>
			
		</cfif>
	</cfif>
</cffunction>