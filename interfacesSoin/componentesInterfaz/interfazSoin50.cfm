<!---
	Interfaz 50 (continuación de la interfaz 10)
	Aplicación de Documentos de Cuentas por Cobrar / Cuentas por Pagar previamente creados por la interfaz 10
--->

<cftransaction isolation="read_uncommitted">
	<cfquery name="readInterfaz50" datasource="sifinterfaces">
		select ID, Modulo, IDdoc
		  from IE50
		 where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
</cftransaction>

<cfif trim(readInterfaz50.Modulo) eq 'CC'>
	<cfinvoke component = "sif.Componentes.CC_PosteoDocumentosCxC"
			  method	= "PosteoDocumento"
				EDid	= "#readInterfaz50.IDdoc#"
				Ecodigo	= "#Session.Ecodigo#"
				usuario	= "#Session.Usuario#"
				debug	= "N"
	/>
<cfelse>
	<cfinvoke component = "sif.Componentes.CP_PosteoDocumentosCxP"
			  method	= "PosteoDocumento"
				IDdoc	= "#readInterfaz50.IDdoc#"
				Ecodigo	= "#Session.Ecodigo#"
				usuario	= "#Session.Usuario#"
				debug	= "N"
		/>
</cfif>
