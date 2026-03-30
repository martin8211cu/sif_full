<cfquery name="TotFils" datasource="#Session.DSN#">
select distinct AnexoFila
from AnexoCel
where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
  and AnexoFila <> 0 
order by AnexoFila
</cfquery>
<cfquery name="Totcols" datasource="#Session.DSN#">
select distinct AnexoColumna
from AnexoCel
where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
  and AnexoColumna <> 0 
order by AnexoColumna
</cfquery>

<cfquery name="rsHojasAnexo" datasource="#Session.DSN#">
	select distinct AnexoHoja 
	from AnexoCel
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>

<cfset filtro = "">
<cfset filtrobd = "">
<cfset navegacion = "">
  
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areafiltro">
		<cfoutput>
		<form name="formfiltroanx" method="post" action="anexo.cfm?AnexoId=#url.AnexoId#&tab=2">		
			<tr>
			    <td align="center" class="etiquetaCampo"><strong>Hoja</strong></td> 						
				<td align="center" class="etiquetaCampo"><strong>Rango</strong></td>				
				<td align="center" class="etiquetaCampo"><strong>Fila</strong></td>						
				<td align="center" class="etiquetaCampo"><strong>Columna</strong></td>				
				<td align="center" class="etiquetaCampo"><strong>Estado</strong></td>
				<td align="center" class="etiquetaCampo"><strong>Cuentas</strong></td>		
				<td align="center" class="etiquetaCampo" colspan="3">&nbsp;</td>					
			</tr>
			<tr>
				<td align="center">
					<cfif isdefined("url.F_Hoja") and len(url.F_Hoja) GT 0>
						<cfset hojaactual = url.F_Hoja>
					<cfelseif isdefined("form.F_Hoja") and len(form.F_Hoja) GT 0>
						<cfset hojaactual = form.F_Hoja>
					<cfelse>
						<cfset hojaactual = "">
					</cfif>					
					
					<select name="F_Hoja">
						<option value=""> Todas</option>
					<cfloop query = "rsHojasAnexo">
						<option value="#AnexoHoja#"
						<cfif trim(hojaactual) eq #trim(AnexoHoja)#>selected</cfif>>
						#trim(AnexoHoja)#						</option>
					</cfloop>
					</select>				</td>
				<td align="center">
					<input name="F_Rango" type="text" size="10"
					<cfif isdefined("form.F_Rango") and len(trim(form.F_Rango)) gt 0>value="#form.F_Rango#"</cfif>>				</td>				
				<td align="center" class="etiquetaCampo">
					<select name="F_fila">
					<option value="0">- Escoger -</option>
					<cfloop query="TotFils">
					<option value="#TotFils.AnexoFila#" <cfif isdefined("form.F_fila") and form.F_fila eq TotFils.AnexoFila>selected</cfif>>#TotFils.AnexoFila#</option>
					</cfloop>
					</select>				</td>
				<td align="center" class="etiquetaCampo">
					<select name="F_columna">
					<option value="0">- Escoger -</option>
					<cfloop query="Totcols">	
						<option value="#Totcols.AnexoColumna#" <cfif isdefined("form.F_columna") and form.F_columna eq Totcols.AnexoColumna>selected</cfif>>
							#fnColumnaExcelFiltro(Totcols.AnexoColumna)#
						</option>
					</cfloop>					
					</select>				
				</td>				
				<td align="center">
					<select name="F_Estado">
						<option value="-1" <cfif isdefined("Form.F_Estado") and Form.F_Estado eq -1>selected</cfif>>- Escoger -</option>
						<option value="3" <cfif isdefined("Form.F_Estado") and Form.F_Estado eq 3>selected</cfif>>Definición OK</option>
						<option value="2" <cfif isdefined("Form.F_Estado") and Form.F_Estado eq 2>selected</cfif>>Sólo en Hoja Excel</option>
						<option value="4" <cfif isdefined("Form.F_Estado") and Form.F_Estado eq 4>selected</cfif>>Con Fórmula en Hoja</option>
						<option value="5" <cfif isdefined("Form.F_Estado") and Form.F_Estado eq 5>selected</cfif>>Multiples Celdas</option>
						<option value="1" <cfif isdefined("Form.F_Estado") and Form.F_Estado eq 1>selected</cfif>>Sólo en Base Datos</option>
					</select>				
				</td>
				<td align="center">				
				
					<select name="F_Cuentas">
					<option value="-1" <cfif isdefined("Form.F_Cuentas") and Form.F_Cuentas eq -1>selected</cfif>>- Escoger -</option>
					<option value="1" <cfif isdefined("Form.F_Cuentas") and Form.F_Cuentas eq 1>selected</cfif>>SI</option>
					<option value="0" <cfif isdefined("Form.F_Cuentas") and Form.F_Cuentas eq 0>selected</cfif>>No</option>
					</select>				</td>
				<td><input type="submit" name="Fltanex" 	value="Filtrar"></td>
				<td><input type="button" name="copyop"  	value="Copiar" 		onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=#url.AnexoId#&amp;copyop=1'" /></td>
				<td><input type="button" name="mover"   	value="Mover"  		onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=#url.AnexoId#&amp;Mover=1'" /></td>
				<td><input type="button" name="eliminar"   	value="Eliminar"  	onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=#url.AnexoId#&amp;Eliminar=1'" /></td>
				<td valign="top" align="right">	
					<img name="imAyuda" src="/cfmx/sif/imagenes/Help01_T.gif" border="0"
					style="cursor:pointer;" onMouseMove="popLayer(1)" onMouseOut="hideLayer(-50)">
				</td>				
			</tr>			
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
		</form>
		</cfoutput>
		</table>
<div id="object1" style="position:absolute; visibility:show; left:10%; width:90%; top:335px; z-index:2"><div>		
<SCRIPT LANGUAGE="JavaScript">
function setupDescriptions() 
{
	var x = navigator.appVersion;
	y = x.substring(0,4);
	if (y>=4) setVariables();
}

var x,y,a,b;
function setVariables()
{
	if (navigator.appName == "Netscape") 
	{
		h=".left=";
		v=".top=";
		dS="document.";
		sD="";
	}
	else 
	{
		h=".pixelLeft=";
		v=".pixelTop=";
		dS="";
		sD=".style";
	}
}
var isNav = (navigator.appName.indexOf("Netscape") !=-1);
function popLayer()
{
	setupDescriptions();

	desc = "<table with='400' border='0' cellspacing='0' cellpadding='0' class='ayuda'><tr>"
    desc += "<td colspan='3' bgcolor='#3399CC' align='center'><strong><font color='#FFFFFF' size='1'>Estado</font></strong></td>"
    desc += "</tr><tr><td height='19' align='right'></td>"

    desc += "<td><img src='../../../imagenes/options.small.png' alt='' width='16' height='16' align='absmiddle' ></td>"
    desc += "<td>El rango está OK: está definido en la Hoja y tiene asignado un Concepto en la Base de Datos.</td></tr><tr><td>&nbsp;</td>"

    desc += "<td><img src='../../../imagenes/toolbar_sub.gif' alt='' width='15' height='20' align='absmiddle' ></td>"
    desc += "<td>El rango está definido solamente en la Hoja: se le puede asignar un Concepto.</td></tr><tr><td>&nbsp;</td>"

    desc += "<td><img src='../../../imagenes/DSL_D.gif' alt='' width='15' height='13' align='absmiddle' ></td>"
    desc += "<td>El rango está definido solamente en la Hoja y tiene una Fórmula: se le puede asignar un Concepto pero se pierde la Fórmula.</td></tr><tr><td>&nbsp;</td>"

    desc += "<td><img src='../../../imagenes/Base.gif' alt='' width='18' height='14' align='absmiddle' ></td>"
    desc += "<td>El rango está definido en la Hoja referenciando varias celdas: no se le puede asignar un Concepto o no se va a Calcular.</td></tr><tr><td>&nbsp;</td>"

    desc += "<td colspan='3' style='color:#FF0000' align='center'><strong>Errores que hay que Corregir</strong></td></tr><tr><td>&nbsp;</td>"

	desc += "<td><img src='../../../imagenes/Recordset.gif' alt='' width='18' height='18' align='absmiddle' >&nbsp;</td>"
    desc += "<td>El rango tiene asignado un Concepto únicamente en la Base de Datos: no se va a calcular.</td></tr><tr><td>&nbsp;</td>"

	desc += "</tr></table>"

	object1.innerHTML=desc;

}
function hideLayer(a)
{
	object1.innerHTML="";
}
</script>		
<cffunction name="fnColumnaExcelFiltro" returntype="string" output="false">
	<cfargument name="Columna" type="numeric">
	
	<cfset var LvarLetraS = "">
	<cfset var LvarLetraN = 0>
	<cfset var LvarColS = "">
	<cfset var LvarColN = Columna>
	<cfloop condition="LvarColN GT 0">
		<cfset LvarLetraN = int((LvarColN-1) mod 26) + 1>
		<cfset LvarLetraS = chr(LvarLetraN + 64)>
		<cfset LvarColS = LvarLetraS & LvarColS>

		<cfset LvarColN = int((LvarColN-1) / 26)>
	</cfloop>
	<cfreturn "#LvarColS#">
</cffunction>
