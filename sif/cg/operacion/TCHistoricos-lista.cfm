<cfoutput>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</td>
	</tr>
	<tr>
		<td colspan="5">
			<cfif isdefined("url.Speriodo") and Len("url.Speriodo") gt 0>
				<cfset form.Speriodo = url.Speriodo >
			</cfif>
			<cfif isdefined("url.Smes") and Len("url.Smes") gt 0>
				<cfset form.Smes = url.Smes >
			</cfif>
			<cfif isdefined("url.Mcodigo") and Len("url.Mcodigo") gt 0>
				<cfset form.Mcodigo = url.Mcodigo >
			</cfif>
			<cfif isdefined("url.TCHid") and Len("url.TCHid") gt 0>
				<cfset form.TCHid = url.TCHid >
			</cfif>
			<cfset Meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
		</td>
	</tr>
	<tr>
		<td colspan="5" class="tituloAlterno">GENERAR TIPOS DE CAMBIO PARA LAS MONEDAS DE CONVERSI&Oacute;N PARA ESTADOS FINANCIEROS</td>
	</tr>
	<tr>
		<td colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5">
			<table border="0" cellspacing="0" cellpadding="2" align="center">
				<tr>
					<td><strong>Per&iacute;odo Contable:</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>#form.Speriodo#&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><strong>Mes Contable:</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>#ListGetAt(meses, form.Smes, ',')#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="5">&nbsp;</td>
	</tr>
	
	<tr>
		<td>
			<cfif isdefined("url.Descripcion") and not isdefined("form.Descripcion") >
				<cfset form.Descripcion = url.Descripcion >
			</cfif>
			
			<cfif isdefined("url.Codigo") and not isdefined("form.Codigo") >
				<cfset form.Codigo = url.Codigo >
			</cfif>
			<form style="margin: 0" action="TCHistoricos.cfm" name="filtroTCH" method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
				<input type="hidden" name="Speriodo" value="#form.Speriodo#">
				<input type="hidden" name="Smes" value="#form.Smes#">
				<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">
				<tr>
					<td align="right"><strong>C&oacute;digo</strong></td>
					<td align="left"><input type="text" name="Codigo" size="8" value="<cfif isdefined('form.Codigo')>#form.Codigo#</cfif>" style="text-transform: uppercase;"></td>
					<td align="right"><strong>Descripci&oacute;n</strong></td>
					<td align="left"><input type="text" name="Descripcion"  value="<cfif isdefined('form.Descripcion')>#form.Descripcion#</cfif>" style="text-transform: uppercase;"></td>    
					<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
				</tr>
				</table>
			</form>
		</td>
	</tr>
	
	<tr>
		<td valign="top" width="46%">
			<cfset navegacion = ''>                   
			<cfif isdefined('form.TCHid') and len(trim(form.TCHid))>
			   <cfset navegacion = "TCHid=#form.TCHid#&">
			</cfif>
			<cfset navegacion = navegacion & "Speriodo=#form.Speriodo#">
			<cfset navegacion = navegacion & "&Smes=#form.Smes#">
			
			<cfquery name="rsHTCambioE" datasource="#Session.DSN#">
				select 	TCHid,Ecodigo,TCHcodigo,TCHdescripcion, #form.Speriodo# as Speriodo, #form.Smes# as Smes, #form.Mcodigo# as Mcodigo
				from    HtiposcambioConversionE   
				where   Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				<cfif isdefined("form.Descripcion") and len(trim(form.Descripcion))>
					and upper(TCHdescripcion) like upper('%#form.Descripcion#%')
				</cfif>
				<cfif isdefined("form.Codigo") and len(trim(form.Codigo))>
					and upper(TCHcodigo) like upper('%#form.Codigo#%')
				</cfif>
			</cfquery>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsHTCambioE#"/>
				<cfinvokeargument name="desplegar" value="TCHcodigo, TCHdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Codigo, Descripci&oacute;n"/>
				<cfinvokeargument name="formatos" value="S,C"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N,N,N"/>
				<cfinvokeargument name="irA" value="TCHistoricos.cfm"/>							
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="TCHid"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="PageIndex" value="1"/>
				<cfinvokeargument name="MaxRows" value="0"/>
			 </cfinvoke>
		</td>
		
		<td valign="top" width="53%" align="center">
			<cfinclude template="TCHistoricos-form.cfm">
		</td>
	</tr>
</table>
</cfoutput>