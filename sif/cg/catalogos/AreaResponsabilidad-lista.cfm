<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->
 
<cfquery name="rsLista" datasource="#Session.DSN#">
	select 
		CGARid, CGARcodigo, CGARdescripcion, CGARresponsable, CGARemail, PCEcatid
		#PreserveSingleQuotes(colsAdicionales)#
	from CGAreaResponsabilidad
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.fCGARcodigo") and Len(Trim(Form.fCGARcodigo))>
		and upper(rtrim(ltrim(CGARcodigo))) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Trim(Form.fCGARcodigo))#%">
	</cfif>
	<cfif isdefined("Form.fCGARdescripcion") and Len(Trim(Form.fCGARdescripcion))>
		and upper(rtrim(ltrim(CGARdescripcion))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(Form.fCGARdescripcion))#%">
	</cfif>
	<cfif isdefined("Form.fCGARresponsable") and Len(Trim(Form.fCGARresponsable))>
		and upper(rtrim(ltrim(CGARresponsable))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(Form.fCGARresponsable))#%">
	</cfif>
	order by CGARcodigo
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Lista de &Aacute;reas de Responsabilidad</strong>
		</td>
      </tr>
	  <tr>
		<td>
			<form name="filtro" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
				<input type="hidden" name="tab" value="#Form.tab#" tabindex="-1">
				<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
				  <tr>
					<td nowrap style="background-color:##CCCCCC"><strong>C&oacute;digo</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Descripci&oacute;n</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Responsable</strong></td>
					<td nowrap style="background-color:##CCCCCC">&nbsp;</td>
				  </tr>
				  <tr>
					<td><input tabindex="4" type="text" name="fCGARcodigo" maxlength="5" size="5" value="<cfif isdefined("form.fCGARcodigo")>#form.fCGARcodigo#</cfif>"></td>
					<td><input tabindex="4" type="text" name="fCGARdescripcion" maxlength="80" size="30" value="<cfif isdefined("form.fCGARdescripcion")>#form.fCGARdescripcion#</cfif>"></td>
					<td><input tabindex="4" type="text" name="fCGARresponsable" maxlength="80" size="30" value="<cfif isdefined("form.fCGARresponsable")>#form.fCGARresponsable#</cfif>"></td>
					<td>
						<input tabindex="4" type="submit" name="btnFiltrar" value="Filtrar">
					</td>
				  </tr>
				</table>
			</form>
		</td>
	  </tr>
	  <tr>
		<td valign="top">
			<cfinvoke
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="CGARcodigo, CGARdescripcion, CGARresponsable"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo &Aacute;rea, Descripci&oacute;n &Aacute;rea, Responsable"/>
				<cfinvokeargument name="formatos" value="S,S,S"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="formName" value="formLista"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="PageIndex" value="1"/>
				<cfinvokeargument name="keys" value="CGARid"/>
				<cfinvokeargument name="maxRows" value="20"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="debug" value="N"/>
			</cfinvoke>
		</td>
	  </tr>
	</table>
</cfoutput>
