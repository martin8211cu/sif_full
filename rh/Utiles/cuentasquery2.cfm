<!--- Tag de Cuentas --->
<!--- parametros para uso del Javascript y asignar valores al Contenedor--->
<cfparam name="url.form" 	default="form1">
<cfparam name="url.mayor" 	default="Cmayor">
<cfparam name="url.fmt" 	default="Cformato">
<cfparam name="url.desc" 	default="Cdescripcion">
<cfparam name="url.id" 		default="Ccuenta">
<cfparam name="url.idF" 	default="CFcuenta">
<cfparam name="url.Ctipo" 	default="">
<cfparam name="url.Cnx" 	default="#Session.DSN#">
<cfparam name="url.Auxiliares" default="N">
<cfparam name="url.Ecodigo" default="#url.Ecodigo#">
<cfparam name="url.Fecha" 	default="">
<cfparam name="url.Ocodigo" default="-1">
<cfparam name="url.CFid" 	default="-1">
<cfparam name="url.NoVerificarPres" default="no" type="boolean">
<cfflush interval="64">
<!--- Si se envio CFcuenta --->
<cfif (isdefined("url.CFcuenta") and len(trim(url.CFcuenta)) NEQ "0")>
	<cfquery name="rsSIFCuentas" datasource="#url.Cnx#">
		select 
			a.CFcuenta, 
			a.Ccuenta, 
			a.Ecodigo, 
			a.Cmayor, 
			a.CFformato, 
						(
							select min(cpv.CPVformatoF)
							  from CPVigencia cpv
							 where cpv.Ecodigo	= b.Ecodigo
							   and cpv.Cmayor	= b.Cmayor
							   and #createODBCdate(Now())# between CPVdesde and CPVhasta
						) as Cmascara,
			case when CFdescripcionF is null OR CFdescripcionF = CFdescripcion then CFdescripcion else {fn concat ({fn concat({fn concat(CFdescripcionF , ' ('  )}, CFdescripcion  )},  ')' )} end as CFdescripcion,
			a.CFmovimiento,
			coalesce(c.Mcodigo, 1) as Auxiliar
		from CFinanciera a
			inner join CtasMayor b
			   on b.Ecodigo	= a.Ecodigo
			  and b.Cmayor 	= a.Cmayor
			<cfif url.Ctipo NEQ "">
			  and b.Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ctipo#">
			</cfif>
			inner join CContables c
			   on c.Ccuenta = a.Ccuenta
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		  and a.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFcuenta#">
	</cfquery>

	<script language="JavaScript">
		<cfoutput>
		<cfset LvarSiExiste = (rsSIFCuentas.RecordCount GT 0) and (Trim(rsSIFCuentas.CFmovimiento) EQ "S")>
		<cfif Trim(url.auxiliares) EQ "S" AND rsSIFCuentas.Auxiliar EQ "1">
			alert("Solo se pueden escoger Cuentas Contables de Auxiliares y la cuenta escogida es de Contabilidad");
			<cfset LvarSiExiste = false>
		<cfelseif Trim(url.auxiliares) EQ "C" AND rsSIFCuentas.Auxiliar NEQ "1">
			alert("Solo se pueden escoger Cuentas Contables de Contabilidad y la cuenta escogida es de Auxiliares");
						
			<cfset LvarSiExiste = false>
		</cfif>
		<cfif LvarSiExiste>
			parent.document.getElementById("#url.mayor#").value			= '#fnJSStringFormat(mid(rsSIFCuentas.CFformato,1,4))#';
			parent.document.getElementById("#url.fmt#").value			= '#fnJSStringFormat(mid(rsSIFCuentas.CFformato,6,100))#';
			parent.document.getElementById("#url.desc#").value			= '#fnJSStringFormat(rsSIFCuentas.CFdescripcion)#';
			parent.document.getElementById("#url.id#").value			= '#fnJSStringFormat(rsSIFCuentas.Ccuenta)#';
			parent.document.getElementById("#url.idF#").value			= '#fnJSStringFormat(rsSIFCuentas.CFcuenta)#';
			parent.document.getElementById("#url.mayor#_mask").value	= '#fnJSStringFormat(rsSIFCuentas.Cmascara)#';
		<cfelse>
			parent.document.getElementById("#url.mayor#").value			= '';
			parent.document.getElementById("#url.fmt#").value			= '';
			parent.document.getElementById("#url.desc#").value			= '';
			parent.document.getElementById("#url.id#").value			= '';
			parent.document.getElementById("#url.idF#").value			= '';
			parent.document.getElementById("#url.mayor#_mask").value	= '';
		</cfif>
		</cfoutput>
	</script>
<!--- Si se digito Cmayor y Cformato --->
<cfelseif (isdefined("url.CFdetalle") and len(trim(url.CFdetalle)) NEQ "") and (isdefined("url.Cmayor") and len(trim(url.Cmayor)) NEQ "")>
	<!--- Esto es la ejecución del Procedimiento almacenado que genera el Plan de Cuentas --->
	<cfinvoke 
	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
	 method="fnGeneraCuentaFinanciera"
	 returnvariable="Lvar_MsgError">
		<cfinvokeargument name="Lprm_Cmayor" 	value="#Trim(url.Cmayor)#"/>
		<cfinvokeargument name="Lprm_Cdetalle" 	value="#Trim(url.CFdetalle)#"/>
		<cfinvokeargument name="Lprm_Ecodigo"	value="#Url.Ecodigo#"/>
		<cfif url.Fecha NEQ "">
			<cfinvokeargument name="Lprm_Fecha"		value="#LSParseDateTime(Url.fecha)#"/>
		</cfif>
		<cfif url.Ocodigo NEQ "-1" AND url.Ocodigo NEQ "">
			<cfinvokeargument name="Lprm_Ocodigo"	value="#url.Ocodigo#"/>
		</cfif>
		<cfif url.CFid NEQ "-1" AND url.CFid NEQ "">
			<cfinvokeargument name="Lprm_Verificar_CFid"	value="#url.CFid#"/>
		</cfif>
		<cfif url.NoVerificarPres>
			<cfinvokeargument name="Lprm_SoloVerificar"		value="yes"/>
			<cfinvokeargument name="Lprm_NoVerificarPres"	value="#url.NoVerificarPres#"/>
		</cfif>
		<cfinvokeargument name="Lprm_CrearSinPlan"		value="no"/>
	</cfinvoke>

	<cfif isdefined('Lvar_MsgError') AND NOT (Lvar_MsgError EQ "OLD" OR Lvar_MsgError EQ "NEW")>
		<script language="javascript">
			<cfoutput>
			
			parent.document.getElementById("#url.id#").value			= '';
			parent.document.getElementById("#url.idF#").value			= '';	
			parent.document.getElementById("#url.desc#").value			= '** ERROR **';
			
			if (!parent.GvarCF_cuentas)
			{
				parent.Gvar_CF_cuentas_#url.id# = true;
				parent.document.getElementById("#url.mayor#").focus();
				alert("#fnJSStringFormat(Lvar_MsgError)#");
				parent.Gvar_CF_cuentas_#url.id# = false;
			}
			</cfoutput>
		</script>
	<cfelse>
		<cfinvoke 
					component="sif.Componentes.PC_GeneraCuentaFinanciera"
					method="fnObtieneCFcuenta"
					returnvariable="rsSIFCuentas"
		>
			<cfinvokeargument name="Lprm_Ecodigo"		value="#Url.Ecodigo#"/>
			<cfinvokeargument name="Lprm_CFformato" 	value="#Trim(url.Cmayor)#-#Trim(url.CFdetalle)#"/>
			<cfif url.Fecha NEQ "">
				<cfinvokeargument name="Lprm_Fecha"		value="#LSParseDateTime(Url.fecha)#"/>
			</cfif>
			<cfinvokeargument name="Lprm_DSN" 			value="#url.Cnx#"/>
		</cfinvoke>

		<cfset LvarSiExiste = (rsSIFCuentas.CFcuenta NEQ "") and (Trim(rsSIFCuentas.CFmovimiento) EQ "S")>

		<script language="JavaScript">
			<cfoutput>
			<cfif Trim(url.auxiliares) EQ "S" AND rsSIFCuentas.Auxiliar EQ "1">
				alert("Solo se pueden escoger Cuentas Financieras de Auxiliares y la cuenta escogida es de Contabilidad");
				<cfset LvarSiExiste = false>
			<cfelseif Trim(url.auxiliares) EQ "C" AND rsSIFCuentas.Auxiliar NEQ "1">
				alert("Solo se pueden escoger Cuentas Financieras de Contabilidad y la cuenta escogida es de Auxiliares");
				<cfset LvarSiExiste = false>
			</cfif>
			<cfif LvarSiExiste>
				parent.document.getElementById("#url.id#").value='#fnJSStringFormat(rsSIFCuentas.Ccuenta)#';
				parent.document.getElementById("#url.idF#").value='#fnJSStringFormat(rsSIFCuentas.CFcuenta)#';
				parent.document.getElementById("#url.desc#").value='#fnJSStringFormat(rsSIFCuentas.CFdescripcion)#';
			<cfelse>
				parent.document.getElementById("#url.id#").value			= '';
				parent.document.getElementById("#url.idF#").value			= '';	
				parent.document.getElementById("#url.desc#").value			= '** ERROR **';
				
				if (!parent.GvarCF_cuentas)
				{
					parent.Gvar_CF_cuentas_#url.id# = true;
					parent.document.getElementById("#url.mayor#").focus();
					parent.Gvar_CF_cuentas_#url.id# = false;
				}
			</cfif>
			</cfoutput>
		</script>
	</cfif>
<!--- Si se solo se digito Cmayor --->
<cfelseif (isdefined("url.Cmayor") and len(trim(url.Cmayor)) NEQ "") >
	<cfquery name="rsMaskCuenta" datasource="#url.Cnx#">
		select 
			a.Ccuenta, 
			a.CFcuenta, 
			m.Ecodigo, 
			m.Cmayor, 
			a.CFformato, 
						(
							select min(cpv.CPVformatoF)
							  from CPVigencia cpv
							 where cpv.Ecodigo	= m.Ecodigo
							   and cpv.Cmayor	= m.Cmayor
							   and #createODBCdate(Now())# between CPVdesde and CPVhasta
						) as Cmascara,
			coalesce(a.CFdescripcion, m.Cdescripcion) as CFdescripcion, 
			coalesce(a.CFmovimiento, 'N') as CFmovimiento
		from CtasMayor m 
			LEFT JOIN CFinanciera a
				ON a.Ecodigo = m.Ecodigo
			   and a.Cmayor = m.Cmayor 
			   and a.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Cmayor#">
		where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
		  and m.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Cmayor#">
		<cfif url.Ctipo NEQ "">
		  and m.Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ctipo#">
		</cfif>
	</cfquery>
	<script language="JavaScript">
		<cfoutput>
		<cfif rsMaskCuenta.RecordCount EQ 0>
				parent.document.getElementById("#url.id#").value			= '';
				parent.document.getElementById("#url.idF#").value			= '';	
				parent.document.getElementById("#url.desc#").value			= '** MAYOR NO EXISTE **';
		<cfelse>
			parent.document.getElementById("#url.mayor#_mask").value="#fnJSStringFormat(rsMaskCuenta.Cmascara)#";
			parent.document.getElementById("#url.desc#").value="#fnJSStringFormat(rsMaskCuenta.CFdescripcion)#";
			<cfif (Trim(rsMaskCuenta.CFmovimiento) EQ "S")>
				parent.document.getElementById("#url.mayor#_id").value="#fnJSStringFormat(rsMaskCuenta.Ccuenta)#";
				parent.document.getElementById("#url.id#").value="#fnJSStringFormat(rsMaskCuenta.Ccuenta)#";
				parent.document.getElementById("#url.idF#").value="#fnJSStringFormat(rsMaskCuenta.CFcuenta)#";
			</cfif>
		</cfif>
		</cfoutput>
	</script>
</cfif>

<cffunction name="fnJSStringFormat" output="no" returntype="string" access="private">
	<cfargument name="hilera" type="string" required="yes">
	
	<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera"
		 method="fnJSStringFormat"
		 returnvariable="LvarHilera"

		 hilera="#Arguments.hilera#" 
	 />
	<cfreturn LvarHilera>
</cffunction>
