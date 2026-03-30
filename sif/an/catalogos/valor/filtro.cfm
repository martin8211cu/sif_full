<!---
	Valores de Variables, esta pantalla tiene 2 sabores, uno cuando el usuario selecciona una oficina, otro cuando el usuario selecciona una variable, 
	y podría haber un tercero si el usuario selecciona las 2 pero no es la idea para que pueda calcular mas rápido.
	Primero: Cuando el usuario selecciona una Oficina. Se pinta una lista con todas las variables, y todos los valores afectan la Oficina seleccionado.
	Segundo: Cuando el usuario selecciona una Variable. Se pinta una lista con todas las oficinas, y todos los valores afectan la Variable seleccionada.
 --->
<!--- Consultas --->
<!--- Año de Auxiliares --->
<cfquery name="rsAno" datasource="#session.dsn#">
	select Pvalor 
	from Parametros
	where Pcodigo = 50
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<!--- Mes de Auxiliares --->
<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor 
	from Parametros
	where Pcodigo = 60
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<!--- Meses en Idioma Local --->
<cfquery name="rsMeses" datasource="#session.dsn#">
	select VSvalor, VSdesc
	from Idiomas a
	inner join VSidioma b
	on a.Iid = b.Iid
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	and VSgrupo = 1
	order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>
<!--- Oficinas de la Empresa --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by Odescripcion
</cfquery>
<!--- Variables de la Corporación --->
<cfquery name="rsVariables" datasource="#session.dsn#">
	select AVid, AVnombre, AVtipo
	from AnexoVar
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<!--- Define Comportamiento de la Pantalla --->
<cfset Lvar_formFiltrado = false>
<cfset Lvar_Oficina = -1>
<cfset Lvar_Variable = -1>
<!--- 1. Identifica si el usuario realizó el filtro inicial --->
<cfif isdefined("form.btnFiltrar")>
	<cfset Lvar_formFiltrado = true>
	<cfset Lvar_formAno = form.AVano>
	<cfset Lvar_formMes = form.AVmes>
	<!--- 2. Indentifica si se filtró por Oficina --->
	<cfif isdefined("form.Ocodigo") and form.Ocodigo neq -1>
		<cfset Lvar_Oficina = form.Ocodigo>
		<cfset rsLista = QueryNew("Name, Description, Value, Tipo")>
		<!--- Consulta los valores de las variables por oficina para todas las variables --->
		<cfquery name="rsValores" datasource="#session.dsn#">
			select AVid, AVvalor 
			from AnexoVarValor
			where AVano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_formAno#">
				and AVmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_formMes#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Oficina#">
		</cfquery>
		<cfloop query="rsVariables">
			<cfquery name="rsValor" dbtype="query">
				select AVvalor 
				from rsValores
				where AVid = #rsVariables.AVid#
			</cfquery>
			<cfif rsValor.recordcount>
				<cfset Lvar_Valor = rsValor.AVvalor>
			<cfelse>
				<cfset Lvar_Valor = "">
			</cfif>
			<cfset rsTemp = QueryAddRow(rsLista,1)>
			<cfset QuerySetCell(rsLista,"Name","#rsVariables.AVnombre#_#Lvar_Oficina#",rsVariables.CurrentRow)>
			<cfset QuerySetCell(rsLista,"Description",rsVariables.AVnombre,rsVariables.CurrentRow)>
			<cfset QuerySetCell(rsLista,"Value","#Lvar_Valor#",rsVariables.CurrentRow)>
			<cfset QuerySetCell(rsLista,"Tipo","#rsVariables.AVtipo#",rsVariables.CurrentRow)>			
		</cfloop>
	<!--- 3. Indentifica si se filtró por Variable --->
	<cfelseif isdefined("form.AVid") and form.AVid neq -1>
		<cfset Lvar_Variable = form.AVid>
		<cfquery name="rsVar" dbtype="query">
			select AVnombre, AVtipo from rsVariables where AVid = #Lvar_Variable#
		</cfquery>
		<cfset rsLista = QueryNew("Name, Description, Value, Tipo")>
		<!--- Consulta los valores de las variables por variable para todas las oficinas --->
		<cfquery name="rsValores" datasource="#session.dsn#">
			select Ocodigo, AVvalor 
			from AnexoVarValor
			where AVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Variable#">
				and AVano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_formAno#">
				and AVmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_formMes#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		</cfquery>
		<cfloop query="rsOficinas">
		<cfquery name="rsValor" dbtype="query">
				select AVvalor 
				from rsValores
				where Ocodigo = #rsOficinas.Ocodigo#
			</cfquery>
			<cfif rsValor.recordcount>
				<cfset Lvar_Valor = rsValor.AVvalor>
			<cfelse>
				<cfset Lvar_Valor = "">
			</cfif>
			<cfset rsTemp = QueryAddRow(rsLista,1)>
			<cfset QuerySetCell(rsLista,"Name","#rsVar.AVnombre#_#rsOficinas.Ocodigo#",rsOficinas.CurrentRow)>
			<cfset QuerySetCell(rsLista,"Description",rsOficinas.Odescripcion,rsOficinas.CurrentRow)>
			<cfset QuerySetCell(rsLista,"Value","",rsOficinas.CurrentRow)>
			<cfset QuerySetCell(rsLista,"Tipo","#rsVar.AVtipo#",rsOficinas.CurrentRow)>
		</cfloop>
	</cfif>
</cfif>
<cfoutput>
<form action="" method="post" name="form1">
		<table width="1%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td><strong>A&ntilde;o : </strong></td>
				<td><label>
					<select name="AVano">
						<cfloop from="#rsAno.Pvalor-3#" to="#rsAno.Pvalor+3#" index="value">
							<option value="#value#" 
									<cfif (not isdefined("form.AVano") and value eq rsAno.Pvalor) or (isdefined("form.AVano") and value eq form.AVano)>
										selected
									</cfif>
							>#value#</option>
						</cfloop>
					</select>
				</label></td>
			</tr>
			<tr>
				<td><strong>Mes : </strong></td>
				<td><label>
					<select name="AVmes">
						<cfloop query="rsMeses">
							<option value="#VSvalor#" 
								<cfif (not isdefined("form.AVmes") and rsMeses.VSvalor eq rsMes.Pvalor) or (isdefined("form.AVmes") and rsMeses.VSvalor eq form.AVmes)>
									selected
								</cfif>
							>#VSdesc#</option>
						</cfloop>
					</select>
				</label></td>
			</tr>
			<tr>
				<td><strong>Oficina : </strong></td>
				<td>
					<select name="Ocodigo">
						<option value="-1" >-todos-</option>
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#" 
								<cfif (isdefined("form.Ocodigo") and rsOficinas.Ocodigo eq form.Ocodigo)>
									selected
								</cfif>
							>#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td><strong>Variable : </strong></td>
				<td>
					<select name="AVid">
						<option value="-1" >-todos-</option>
						<cfloop query="rsVariables">
							<option value="#rsVariables.AVid#" 
								<cfif (isdefined("form.AVid") and rsVariables.AVid eq form.AVid)>
									selected
								</cfif>
							>#rsVariables.AVnombre#</option>
						</cfloop>
					</select>
				</td>
			</tr>
		</table>
		<cf_botones values="Filtrar">
</form>
<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
	objForm.AVano.description = "#JSStringFormat('Año')#";
	objForm.AVmes.description = "#JSStringFormat('Mes')#";
	objForm.Ocodigo.description = "#JSStringFormat('Oficina')#";
	objForm.AVid.description = "#JSStringFormat('Variable')#";
	function habilitarValidacion(){
		objForm.AVano.required = true;
		objForm.AVmes.required = true;
		objForm.Ocodigo.validateExp("_validateOfiVar()","Se requiere que seleccione una oficina o una variable o ambos.");
	}
	function desahabilitarValidacion(){
		objForm.AVano.required = false;
		objForm.AVmes.required = false;
		objForm.Ocodigo.validateExp("");
	}
	function _validateOfiVar(){
		if (objForm.Ocodigo.getValue()=='-1'&&objForm.AVid.getValue()=='-1'){
			return true;
		}
		return false;
	}
	habilitarValidacion();
	objForm.AVano.obj.focus();
//-->
</script>
</cfoutput>