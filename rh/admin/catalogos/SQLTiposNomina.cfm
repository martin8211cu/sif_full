<cfinvoke key="LB_El_Tipo_de_Nomina_no_puede_ser_eliminada_debido_a_que_existen_nominas_generadas_que_dependen_de_este_tipo." default="El Tipo de Nomina no puede ser eliminada debido a que existen nominas generadas que dependen de este tipo." returnvariable="LB_ErrorTipoNomi" component="sif.Componentes.Translate" method="Translate"/>
<cfif not isdefined("Form.Nuevo")>

	<cffunction name="datos" >
		<cfargument name="tcodigo" type="string" required="true">
		<cfargument name="dtndia"  type="numeric" required="true">

		<cfquery name="rsDatos" datasource="#Session.DSN#">
			insert into DiasTiposNomina(Ecodigo, Tcodigo, DTNdia, Usucodigo, Ulocalizacion)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#tcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#dtndia#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				'00'
			)
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cfif isdefined("Form.Alta")>
		<cfquery name="ABC_TiposNomina" datasource="#Session.DSN#">
			insert into TiposNomina (Ecodigo, Tcodigo, Tdescripcion, Ttipopago, Mcodigo, FactorDiasSalario, FactorDiasIMSS, IRcodigo,TipoNomina,CalculaCargas,AjusteMensual,TRegimen)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ttipopago#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
				<cfif isdefined("Form.FactorDiasSalario") and len(trim(Form.FactorDiasSalario))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(form.FactorDiasSalario, ',','','all')#">
				<cfelse>
					null
				</cfif>
                <cfif isdefined("Form.FactorDiasIMSS") and len(trim(Form.FactorDiasIMSS))>
					,<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.FactorDiasIMSS, ',','','all')#">
				<cfelse>
					,null
				</cfif>
                <cfif isdefined("Form.IRcodigo") and len(trim(Form.IRcodigo))>
					,<cfqueryparam cfsqltype="cf_sql_char" value="#form.IRcodigo#">
				<cfelse>
					,null
				</cfif>
				<!--- Oparrales cambios para integrar informacion en XML Boletas de Pago --->
				,<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TtipoNomina)#">
				<!--- OPARRALES 2018-08-06 Check para excluir el calculo de las cargas en las Relaciones de Calculo --->
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#(IsDefined('form.CalculaCargas') ? 1 : 0)#">
				<!--- OPARRALES 2018-07-19 Check para Saber si realiza Ajuste mensual en el calculo de ISR --->
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#(IsDefined('form.AjusteMensual') ? 1 : 0)#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRegimen#">
			)
		</cfquery>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Baja")>
		<cftry>

			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="DiasTiposNomina">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#'">
			</cfinvoke>

			<cfquery name="ABC_TiposNomina_dtn" datasource="#Session.DSN#">
				delete from DiasTiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
			</cfquery>

			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="TiposNomina">
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#'">
			</cfinvoke>

			<cfquery name="ABC_TiposNomina_tn" datasource="#Session.DSN#">
				delete from TiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
			</cfquery>
			<cfset modo="ALTA">
			<cfcatch type="any">
				<cf_throw message="#LB_ErrorTipoNomi#" errorcode="48">
			</cfcatch>

		</cftry>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#Session.DSN#"
			table="TiposNomina"
			redirect="formTiposNomina.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo"
			type1="integer"
			value1="#Session.Ecodigo#"
			field2="Tcodigo"
			type2="varchar"
			value2="#form.Tcodigo#"	>

		<cfquery name="ABC_updTiposNomina" datasource="#session.DSN#">
			update TiposNomina set
				Tdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tdescripcion#">,
				Ttipopago = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ttipopago#">,
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
				<cfif isdefined("Form.FactorDiasSalario") and len(trim(Form.FactorDiasSalario))>
					FactorDiasSalario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FactorDiasSalario#">
				<cfelse>
					FactorDiasSalario = null
				</cfif>
                <cfif isdefined("Form.FactorDiasIMSS") and len(trim(Form.FactorDiasIMSS))>
					,FactorDiasIMSS =  <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.FactorDiasIMSS, ',','','all')#">
				<cfelse>
					,FactorDiasIMSS = null
				</cfif>
                <cfif isdefined("Form.IRcodigo") and len(trim(Form.FactorDiasIMSS))>
					,IRcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.IRcodigo#">
				<cfelse>
					,IRcodigo = null
				</cfif>
				<!--- Oparrales cambios para integrar informacion en XML Boletas de Pago --->
				, TipoNomina = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TtipoNomina)#">
				<!--- OPARRALES 2018-08-06 Check para excluir el calculo de las cargas en las Relaciones de Calculo --->
				, CalculaCargas = <cfqueryparam cfsqltype="cf_sql_integer" value="#(IsDefined('form.CalculaCargas') ? 1 : 0)#">
				<!--- OPARRALES 2018-07-19 Check para Saber si realiza Ajuste mensual en el calculo de ISR --->
				, AjusteMensual = <cfqueryparam cfsqltype="cf_sql_integer" value="#(IsDefined('form.AjusteMensual') ? 1 : 0)#">
				, Contabilizar = <cfqueryparam cfsqltype="cf_sql_integer" value="#(IsDefined('form.Contabilizar') ? 1 : 0)#">
				, TRegimen  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TRegimen#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				<!--- muy raro el rtrim , pero si no se hace asi no agarra el update porque 'xx' != 'xx ' en oracle 9.2.0.1.0 --->
			  	and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
				<!--- '#Form.Tcodigo#' --->
		</cfquery>
		<cfset modo="CAMBIO">

	</cfif>


	<cfif isdefined("Form.Cambio") or isdefined("Form.Alta") >
		<cfif isdefined("Form.Cambio")>

			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="DiasTiposNomina">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#'">
			</cfinvoke>

			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from DiasTiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
			</cfquery>
		</cfif>

		<cfif isdefined("form.DTNdia_1")><cfset datos(form.Tcodigo, 1)></cfif>
		<cfif isdefined("form.DTNdia_2")><cfset datos(form.Tcodigo, 2)></cfif>
		<cfif isdefined("form.DTNdia_3")><cfset datos(form.Tcodigo, 3)></cfif>
		<cfif isdefined("form.DTNdia_4")><cfset datos(form.Tcodigo, 4)></cfif>
		<cfif isdefined("form.DTNdia_5")><cfset datos(form.Tcodigo, 5)></cfif>
		<cfif isdefined("form.DTNdia_6")><cfset datos(form.Tcodigo, 6)></cfif>
		<cfif isdefined("form.DTNdia_7")><cfset datos(form.Tcodigo, 7)></cfif>

	</cfif>

<cfelse>
	<cflocation url="TiposNomina.cfm">
</cfif>

<form action="TiposNomina.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#trim(modo)#</cfoutput></cfif>">
	<cfif isdefined("ABC_TiposNomina.Tcodigo")>
	   	<input name="Tcodigo" type="hidden" value="<cfif isdefined("ABC_TiposNomina.Tcodigo")><cfoutput>#ABC_TiposNomina.Tcodigo#</cfoutput></cfif>">
	<cfelseif isdefined("modo") and modo neq 'ALTA'>
	   	<input name="Tcodigo" type="hidden" value="<cfoutput>#Form.Tcodigo#</cfoutput>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">


	<!--- filtros de la lista --->
	<cfoutput>
	<cfif isdefined("form.f_codigo") and len(trim(form.f_codigo)) >
		<input type="hidden" name="f_codigo" value="#form.f_codigo#" />
	</cfif>
	<cfif isdefined("form.f_descripcion") and len(trim(form.f_descripcion))>
		<input type="hidden" name="f_descripcion" value="#form.f_descripcion#" />
	</cfif>
	<cfif isdefined("form.f_tipopago") and len(trim(form.f_tipopago))>
		<input type="hidden" name="f_tipopago" value="#form.f_tipopago#" />
	</cfif>
	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
		<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#" />
	</cfif>
	</cfoutput>

</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

