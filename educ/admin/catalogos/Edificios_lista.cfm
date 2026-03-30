<cfquery datasource="#Session.DSN#" name="rsSede">
	select convert(varchar,b.Scodigo) as Scodigo, rtrim(b.Snombre) as Snombre,
		Scodificacion, Sprefijo 	
		from Sede b
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfif isdefined("Url.EDnombre") and not isdefined("Form.EDnombre")>
	<cfparam name="Form.EDnombre" default="#Url.EDnombre#">
</cfif>

<form name="Edificio_filtro" method="post" action="Edificios.cfm">
	<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
	  <tr>
		<td align="left" nowrap><strong>Sede</strong></td>
		<td align="left" nowrap><strong>Nombre de Edificio</strong></td>
		<td align="center"  nowrap><strong>Prefijo del Aula</strong></td>
		<td align="center"  nowrap>&nbsp;</td>
	  </tr>
	  <tr align="left">
		<td width="19%" nowrap>
			<select name="Scodigo">
			 <option value="-1" <cfif isdefined("form.Scodigo") and form.Scodigo EQ "-1">selected</cfif>>- 
					Todos -</option>
			  <cfoutput query="rsSede">
				<option value="#rsSede.Scodigo#" <cfif isdefined("form.Scodigo") and rsSede.Scodigo EQ form.Scodigo>selected</cfif>>#rsSede.Snombre#</option>
			  </cfoutput>
			</select>
</td>
		<td width="48%" nowrap><input name="EDnombre" type="text" id="EDnombre2" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.EDnombre") AND Form.EDnombre NEQ ""><cfoutput>#Form.EDnombre#</cfoutput></cfif>">
</td>
		<td align="center"><input name="EDprefijo" type="text" id="EDprefijo" size="10" tabindex="1" maxlength="3" onFocus="javascript:this.select();" value="<cfif isdefined("Form.EDprefijo") ><cfoutput>#Form.EDprefijo#</cfoutput></cfif>">
		</td>
		<td align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Buscar"></td>
	  </tr>
	</table>
</form>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.EDnombre") AND Form.EDnombre NEQ "">
	<cfset filtro = "and upper(rtrim(EDnombre)) like upper('%" & #Trim(Form.EDnombre)# & "%')">
	<cfset navegacion = "EDnombre=" & Form.EDnombre>
</cfif>
<cfif isdefined("Form.Scodigo") AND Form.Scodigo NEQ "" and form.Scodigo NEQ -1>
	<cfset filtro = filtro & "and a.Scodigo =" & #Form.Scodigo# >
	<cfset navegacion = "Scodigo=" & Form.Scodigo>
</cfif>
<cfif isdefined("Form.EDprefijo") AND Form.EDprefijo NEQ "">
	<cfset filtro = filtro & "and upper(rtrim(EDprefijo)) like upper('%" & #Trim(Form.EDprefijo)# & "%')">
	<cfset navegacion = "EDprefijo=" & Form.EDprefijo>
</cfif>				
<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="Edificio a, Sede b"/>
	<cfinvokeargument name="columnas" value="convert(varchar,a.EDcodigo) as EDcodigo, substring(a.EDnombre,1,50) as EDnombre, 
							convert(varchar,a.ts_rversion) as ts_rversion, a.EDcodificacion as EDcodificacion, a.EDprefijo,
							rtrim(b.Scodificacion) + ' - ' + b.Snombre as Sprefijo, convert(varchar,b.Scodigo) as Scodigo"/>
	<cfinvokeargument name="desplegar" value="EDcodificacion, EDnombre, EDprefijo"/>
	<cfinvokeargument name="etiquetas" value="Código, Nombre Edificio, Prefijo del Aula"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" a.Ecodigo = #session.Ecodigo# 
											#filtro# and a.Ecodigo = b.Ecodigo 
											and a.Scodigo = b.Scodigo
											order by b.Sorden, b.Sprefijo asc"/>
	<cfinvokeargument name="align" value="left,left,left"/>
	<cfinvokeargument name="ajustar" value="N,N,N"/>
	<cfinvokeargument name="cortes" value="Sprefijo"/>
	<cfinvokeargument name="irA" value="Edificios.cfm"/>
	<cfinvokeargument name="botones" value="Nuevo"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="navegacion" value="#navegacion#" />
</cfinvoke>
