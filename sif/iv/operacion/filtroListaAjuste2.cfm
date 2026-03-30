
<!-- Consultas -->

<!-- 1. Combo Almacen -->
<cfquery datasource="#Session.DSN#" name="rsAlmacen">

	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion

</cfquery>

<!-- 1. Combo Almacen -->
<cfquery datasource="#Session.DSN#" name="rsUsuario">

	select distinct EAusuario
	from EAjustes ea, Almacen a
	where ea.Aid=a.Aid
	and a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by EAusuario

</cfquery>	

<script language="JavaScript" type="text/JavaScript">

	// ==================================================================================================
	// 								Usadas para conlis de fecha
	// ==================================================================================================
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	// ==================================================================================================
	// ==================================================================================================	
	
</script>

<form action="listaAjuste.cfm" method="post" name="fajuste" >
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="baseline">Almacen:</td>
			<td>
				<select name="fAid" >
					<cfoutput query="rsAlmacen">					
						<option value="#rsAlmacen.Aid#" <cfif isdefined("form.fAid") and #form.fAid# EQ #rsAlmacen.Aid#>selected</cfif> >#rsAlmacen.Bdescripcion#</option>
					</cfoutput>						
				</select>
			</td>
			
			<td valign="baseline">Documento:</td>
			<td>
				<input type="text" name="fEAdocumento" size="15" maxlength="20" value="<cfif isdefined("form.fEAdocumento") and #form.fEAdocumento# neq "" >#form.EAdocumento#</cfif>" >
			</td>
			
			<td valign="baseline">Descripci&oacute;n:</td>
			<td>
				<input type="text" name="fEAdescripcion" size="30" maxlength="80" value="<cfif isdefined("form.fEAdescripcion") and #form.fEAdescripcion# neq "" >#form.fEAdescripcion#</cfif>" >
			</td>
				
			<td>Fecha:</td>
		    <td>
				<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/sif/imagenes/DATE_D.gif',1)"> 
					<input name="fEAfecha" type="text" value="<cfif isdefined("form.fEAfecha") and #form.fEAfecha# neq "" ><cfoutput>#form.fEAfecha#</cfoutput><cfelse><cfoutput>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="10" maxlength="10" >
					<img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.fajuste.fEAfecha');">
				</a>
			</td>
			
			<td valign="baseline">Usuario:</td>
			<td>
				<select name="fUsuario" >
					<option value="all">Todos</option>
					<cfoutput query="rsUsuario">					
						<option value="#rsUsuario.EAusuario#" <cfif isdefined("form.fUsuario") and #form.fUsuario# EQ #rsUsuario.EAusuario#>selected</cfif> >#rsUsuario.EAusuario#</option>
					</cfoutput>						
				</select>
			</td>

			<td>
				<input type="submit" name="btnFiltro"  value="Filtrar">
				<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
			</td>
		</tr>
	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.fajuste.fAid.value           = ""
		document.fajuste.fEAdocumento.value   = ""
		document.fajuste.fEAdescripcion.value = ""
		document.fajuste.fEAfecha.value       = ""
		document.fajuste.fUsuario.value       = ""		
	}
</script>
