<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 22-2-2006.
		Motivo: Se modifica para que funcione en Oracle y Sybase.
 --->
<cfinvoke key="BTN_Filtro" 	default="Filtro" returnvariable="BTN_Filtro" component="sif.Componentes.Translate" method="Translate" 
xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Codigo" 	default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" 
xmlfile="ConlisCFuncional.xml"/>
<cfinvoke key="LB_Oficina" 	default="Oficina" returnvariable="LB_Oficina" component="sif.Componentes.Translate" method="Translate" 
xmlfile="ConlisCFuncional.xml"/>
<cfinvoke key="LB_Descripcion" 	default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" 
method="Translate"  xmlfile="ConlisCFuncional.xml"/>
<cfinvoke key="LB_Departamento" 	default="Departamento" returnvariable="LB_Departamento" component="sif.Componentes.Translate" 
method="Translate" xmlfile="ConlisCFuncional.xml"/>
<cfinvoke key="LB_Estado" 	default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate" 
xmlfile="ConlisCFuncional.xml"/>
<cfinvoke key="LB_Activo" 	default="Activo" returnvariable="LB_Activo" component="sif.Componentes.Translate" method="Translate" 
xmlfile="ConlisCFuncional.xml"/>

  <cfinclude template="/rh/Utiles/params.cfm">
  <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>

	<cfif isdefined("url.CFcodigof") and len(trim(url.CFcodigof))NEQ 0>
		<cfset form.CFcodigof = url.CFcodigof> 
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
	
	<cfparam name="form.Activof" default="1">
	<cfif isdefined("url.Activof") and len(trim(url.Activof))NEQ 0>
		<cfset form.Activof=url.Activof> 
	</cfif>
	
	
	<cfif isdefined("url.excluir") and len(trim(url.excluir))NEQ 0 and url.excluir neq -1>
		<cfset form.excluir=url.excluir> 
	</cfif>
	
	<cfif isdefined("url.contables") and len(trim(url.contables))NEQ 0 and url.contables neq -1>
		<cfset form.contables=url.contables> 
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
	
	<cfif isdefined("form.excluir") and len(trim(form.excluir))NEQ 0 and form.excluir neq -1>
		<cfif len(trim(navegacion)) NEQ 0>	
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "excluir="&form.excluir>
			<cfelse> 	
				<cfset navegacion = navegacion & "excluir="&form.excluir>
		</cfif>
	</cfif>
	<cfif isdefined("form.Activof") and len(trim(form.Activof))>
    	<cfif len(trim(navegacion)) NEQ 0>	
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Activof="&form.Activof>
			<cfelse> 	
				<cfset navegacion = navegacion & "Activof="&form.Activof>
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
			if (window.opener.func#trim(Url.name)#) {window.opener.func#trim(Url.name)#();}
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
									<td><cf_translate key=LB_Codigo>Código</cf_translate></td>
									<td><cf_translate key=LB_Descripcion>Descripción</cf_translate></td>
									<td><cf_translate key=LB_Oficina>Oficina</cf_translate></td>
									<td><cf_translate key=LB_Departamento>Departamento</cf_translate></td>
									<td><cf_translate key=LB_Estado>Estado</cf_translate></td>
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
										<select name="Activof" tabindex="1">
											<option value="1"><cf_translate key=LB_Activo>Activo</cf_translate></option>
											<option value="0"><cf_translate key=LB_Inactivo>Inactivo</cf_translate></option>
											
										</select>								
									</td>
									<td>

										<cfoutput><input name="BTNfiltro" type="submit" value="#BTN_Filtro#" tabindex="1"></cfoutput>
									</td>
								</tr>
							</table>
						</form>
					</td>
				</tr>
						
				<tr>
					<td>
						<cf_dbfunction name='OP_concat' returnvariable='concat'>
						<cfquery name="rsCentros" datasource="#session.DSN#" >
							select distinct 
							a.CFid as CFpk,
							a.CFcodigo,
							a.CFdescripcion,  
							<cf_dbfunction name="to_char" args="b.Oficodigo"> #concat# '-' #concat# b.Odescripcion as Oficina,  
							<cf_dbfunction name="to_char" args="a.Dcodigo"> #concat# '-' #concat# c.Ddescripcion as Depto,
							
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
								,'<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# (case a.CFestado when 0 then 'un' else null end)  #_Cat# 'checked.gif''>'  as Activo
										
							from  CFuncional a
										
							inner join Oficinas b
								on  b.Ocodigo=a.Ocodigo
								and b.Ecodigo=a.Ecodigo
										
							inner join	Departamentos c
								on c.Dcodigo=a.Dcodigo
								and  c.Ecodigo=a.Ecodigo
											
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
										
							<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
								and ltrim(rtrim(upper(a.CFcodigo))) like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#trim(ucase(form.CFcodigof))#%">
							</cfif>
										
							<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
								and ltrim(rtrim(upper(a.CFdescripcion))) like  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#rtrim(Ucase(form.CFdescripcionf))#%">
							</cfif>
										
							<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
								and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigof#">
							</cfif>
										
							<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
								and a.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigof#">
							</cfif>
							<cfif isdefined("form.excluir") and len(trim(form.excluir)) NEQ 0>
								and a.CFid not in(<cfqueryparam cfsqltype="cf_sql_integer" value="#form.excluir#" list="yes">)
							</cfif>
							
							<cfif isdefined("form.Activof") and len(trim(form.Activof))NEQ 0>
								and a.CFestado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.Activof#">
							</cfif>
							
							<cfif isdefined("form.contables") and form.contables NEQ -1>
								and a.CFcuentac is not null
									and ltrim(rtrim(CFcuentac)) > ' '
							</cfif>
							
							
										
							order by a.CFpath, a.CFcodigo, a.CFnivel
						</cfquery>
						<cfinvoke
						Component= "rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsCentros#"/>
							<cfinvokeargument name="desplegar" value="CFcodigo,CFdescripcion,Oficina,Depto,Activo"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Oficina#,#LB_Departamento#,#LB_Activo#"/>
							<cfinvokeargument name="formatos" value="V,V,V,V,IMG"/>
							<cfinvokeargument name="incluyeform" value="true"/>
							<cfinvokeargument name="formname" value="form2"/>
							<cfinvokeargument name="align" value="left,left,left,left,Center"/>
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
