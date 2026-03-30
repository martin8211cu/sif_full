
<!-- Consultas -->

<!-- 1. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">

	select Aid, Bdescripcion
	from Almacen 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion

</cfquery>

<!-- 1. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsUsuario">

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

<script language="JavaScript1.2" type="text/javascript" src="../../js/calendar.js"></script>

<form style="margin: 0" action="listaAjuste.cfm" name="fajuste" method="post" >

	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">

		<tr>
			<td width="8">&nbsp;</td>
			<td>Documento</td>
			<td width="120">&nbsp;</td>
			<td>Descripci&oacute;n</td>
			<td width="80">&nbsp;</td>
			<td>Almac&eacute;n</td>
			<td>Fecha</td>
			<td colspan="2" >Usuario</td>
		</tr>	

		<tr>
			<td class="subTitulo" width="8">&nbsp;</td>
			<td class="subTitulo">
				<input type="text" name="fEAdocumento" size="15" maxlength="20" value="" style="text-transform: uppercase;" >
			</td>
			
			<td class="subTitulo" width="120">&nbsp;</td>
			<td class="subTitulo">
				<input type="text" name="fEAdescripcion" size="30" maxlength="80" value="" style="text-transform: uppercase;" >
			</td>

			<td class="subTitulo" width="80">&nbsp;</td>
			<td class="subTitulo">
				<select name="fAid" >
					<option value="all">Todos</option>
					<cfoutput query="rsAlmacen">					
						<option value="#rsAlmacen.Aid#" >#rsAlmacen.Bdescripcion#</option>
					</cfoutput>						
				</select>
			</td>
			
			<td><cf_sifcalendario form="fajuste" name="fEAfecha"></td>
			
			<td class="subTitulo">
				<select name="fUsuario" >
					<option value="all">Todos</option>
					<cfoutput query="rsUsuario">					
						<option value="#rsUsuario.EAusuario#" >#rsUsuario.EAusuario#</option>
					</cfoutput>						
				</select>
			</td>

			<td class="subTitulo">
				<input type="submit" name="btnFiltro"  value="Filtrar">
			</td>
		</tr>
	</table>
</form>