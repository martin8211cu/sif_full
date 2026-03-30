<!---
	Modificado por Gustavo Fonseca H.
		Fecha: 22-2-2006.
		Motivo: Se modifica para que funcione en Oracle y Sybase.
 --->

  <cfinclude template="../Utiles/params.cfm">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>

  <cfif not isdefined("url.Ecodigo") or len(trim(url.Ecodigo)) eq 0>
    <cfset url.Ecodigo = session.Ecodigo>
  </cfif>


	<cfif isdefined("url.CFcodigof") and len(trim(url.CFcodigof))NEQ 0>
		<cfset form.CFcodigof=url.CFcodigof>
	</cfif>

	<cfif isdefined("url.CFdescripcionf") and len(trim(url.CFdescripcionf))NEQ 0>
		<cfset form.CFdescripcionf=url.CFdescripcionf>
	</cfif>

	<cfif isdefined("url.Ocodigof") and len(trim(url.Ocodigof))NEQ 0>
		<cfset form.Ocodigof=url.Ocodigof>
	</cfif>
	<cfif isdefined("url.Dcodigof") and len(trim(url.Dcodigof))NEQ 0>
		<cfset form.Dcodigof=url.Dcodigof>
	</cfif>

	<cfset navegacion = "">

	<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
		<cfset navegacion = navegacion  &  "CFcodigof="&form.CFcodigof>
	</cfif>

	<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
		<cfif len(trim(navegacion)) NEQ 0>
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "CFdescripcionf="&form.CFdescripcionf>
			<cfelse>
				<cfset navegacion = navegacion & "CFdescripcionf="&form.CFdescripcionf>
		</cfif>
	</cfif>

	<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
		<cfif len(trim(navegacion)) NEQ 0>
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Ocodigof="&form.Ocodigof>
			<cfelse>
				<cfset navegacion = navegacion & "Ocodigof="&form.Ocodigof>
		</cfif>
	</cfif>

	<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
		<cfif len(trim(navegacion)) NEQ 0>
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Dcodigof="&form.Dcodigof>
			<cfelse>
				<cfset navegacion = navegacion & "Dcodigof="&form.Dcodigof>
		</cfif>
	</cfif>


<script type="text/javascript" language="javascript">
	<!--- Recibe conexion, form, name y desc --->
	function Asignar(id,name,desc) {
		if (window.opener != null) {
			<cfoutput>
			var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
			window.opener.document.#Url.form#.#Url.id#.value   = id;
			window.opener.document.#Url.form#.#Url.name#.value = name;
			window.opener.document.#Url.form#.#Url.desc#.value = desc;
			try{
				if (window.opener.func#trim(Url.name)#) {window.opener.func#trim(Url.name)#();}
			}
			catch(err) {
			    //todo
			}
			window.opener.document.#Url.form#.#Url.name#.focus();
			</cfoutput>
			window.close();
		}
	}
</script>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">

			<table width="100%">
				<tr>
					<td class="tituloListas">
						<form name="form1" method="post">
							<table width="100%">
								<tr>
									<td>Código</td>
									<td>Descripción</td>
									<td>Oficina</td>
									<td>Departamento</td>
									<td></td>
								</tr>
								<tr>
									<td>
										<input name="CFcodigof" type="text" size="8" maxlength="10" tabindex="1"
											value="<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0><cfoutput>#form.CFcodigof#</cfoutput></cfif>"/>
									</td>
									<td>
										<input name="CFdescripcionf" type="text"  size="30" maxlength="60" tabindex="1"
											value="<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0><cfoutput>#form.CFdescripcionf#</cfoutput></cfif>"/>
									</td>
									<td>
										<cfquery name="rsOficinas" datasource="#session.DSN#">
										select Ocodigo, Oficodigo, Odescripcion  as  Odescripcion
										from Oficinas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ecodigo#">
										</cfquery>
										<select name="Ocodigof" tabindex="1">
											<option value=""></option>
											<cfloop query="rsOficinas">
												<option value="<cfoutput>#rsOficinas.Ocodigo#</cfoutput>" <cfif isdefined("form.Ocodigof") and form.Ocodigof EQ rsOficinas.Ocodigo> selected </cfif>><cfoutput>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</cfoutput></option>
											</cfloop>
										</select>								</td>
									<td>
										<cfquery name="rsDeptos" datasource="#session.DSN#">
										select Dcodigo, Deptocodigo, Ddescripcion
										from Departamentos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ecodigo#">
										</cfquery>
										<select name="Dcodigof" tabindex="1">
											<option value=""></option>
											<cfloop query="rsDeptos">
												<option value="<cfoutput>#rsDeptos.Dcodigo#</cfoutput>" <cfif isdefined("form.Dcodigof") and form.Dcodigof EQ rsDeptos.Dcodigo> selected </cfif>><cfoutput>#rsDeptos.Deptocodigo# - #rsDeptos.Ddescripcion#</cfoutput></option>
											</cfloop>
										</select>
									</td>
									<td>

										<input name="BTNfiltro" type="submit" value="Filtro" tabindex="1">
									</td>
								</tr>
							</table>
						</form>
					</td>
				</tr>

				<tr>
					<td>
					    <cf_dbfunction name="OP_CONCAT" returnvariable="Concat">
						<cfquery name="rsCentros" datasource="#session.DSN#" >
							select distinct
							a.CFid as CFpk,
							a.CFcodigo,
							a.CFdescripcion,
							<cf_dbfunction name="to_char" args="a.Ocodigo"> #Concat# '-' #Concat# b.Odescripcion as Oficina,
							<cf_dbfunction name="to_char" args="a.Dcodigo"> #Concat# '-' #Concat# c.Ddescripcion as Depto,

							a.CFid as primero,
							a.CFpath,
							a.CFnivel

								 <cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
									,<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CFcodigof#"> as CFcodigof
								</cfif>

								<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
									,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.CFdescripcionf#"> as CFdescripcionf
								</cfif>

								<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
									,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.Ocodigof#"> as Ocodigof
								</cfif>

								<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
									,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.Dcodigof#"> as Dcodigof
								</cfif>

							from  CFuncional a

							inner join Oficinas b
								on  b.Ocodigo=a.Ocodigo
								and b.Ecodigo=a.Ecodigo

							inner join	Departamentos c
								on c.Dcodigo=a.Dcodigo
								and  c.Ecodigo=a.Ecodigo

							where a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#url.Ecodigo#">

							<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
								and ltrim(rtrim(upper(a.CFcodigo))) like '%#trim(ucase(form.CFcodigof))#%'
							</cfif>

							<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
								and ltrim(rtrim(upper(a.CFdescripcion))) like '%#trim(ucase(form.CFdescripcionf))#%'
							</cfif>

							<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
								and a.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.Ocodigof#">
							</cfif>

							<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
								and a.Dcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.Dcodigof#">
							</cfif>

							order by a.CFpath, a.CFcodigo, a.CFnivel
						</cfquery>

						<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsCentros#"/>
							<cfinvokeargument name="desplegar" value="CFcodigo,CFdescripcion,Oficina,Depto"/>
							<cfinvokeargument name="etiquetas" value="Codigo,Descripcion,Oficina,Departamento"/>
							<cfinvokeargument name="formatos" value="V,V,V,V"/>

							<cfinvokeargument name="incluyeform" value="true"/>
							<cfinvokeargument name="formname" value="form2"/>
							<cfinvokeargument name="align" value="left,left,left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="funcion" value="Asignar"/>
							<cfinvokeargument name="fparams" value="CFpk,CFcodigo,CFdescripcion"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="IrA" value="ConlisCFuncional.cfm"/>
							<cfinvokeargument name="maxrows" value="15"/>
						</cfinvoke>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
