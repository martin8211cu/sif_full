<!-- Consultas -->

<!-- 1. Combo periodos -->
<cfquery datasource="#Session.DSN#" name="rsPeriodos">

	select distinct ETperiodo 
	from ETraspasos
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	order by ETperiodo

</cfquery>	

<!-- 2. Combo Meses -->
<cfquery datasource="#Session.DSN#" name="rsMes">

	select distinct ETmes 
	from ETraspasos
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by ETmes

</cfquery>	

<!-- 3. Combo Usuario -->
<cfquery datasource="#Session.DSN#" name="rsUsuarios">

	select distinct ETusuario 
	from ETraspasos
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by ETusuario

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

	function MM_preloadImages() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

	// ==================================================================================================
	// ==================================================================================================	
	
</script>

<!--- Inclusion de JS de fecha --->
<script language="JavaScript1.2" type="text/javascript" src="../../js/calendar.js"></script>

<body onLoad="MM_preloadImages('/cfmx/sif/imagenes/DATE_D.gif')">

<cfset meses = ArrayNew(1)>
<cfset meses[1]  = "Enero">
<cfset meses[2]  = "Febrero">
<cfset meses[3]  = "Marzo">
<cfset meses[4]  = "Abril">
<cfset meses[5]  = "Mayo">
<cfset meses[6]  = "Junio">
<cfset meses[7]  = "Julio">
<cfset meses[8]  = "Agosto">
<cfset meses[9]  = "Setiembre">
<cfset meses[10] = "Octubre">
<cfset meses[11] = "Noviembre">
<cfset meses[12] = "Diciembre">

<form style="margin:0" action="Transferencias.cfm" name="ftransferencias" method="post" >
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td nowrap align="right"><strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;</td>
			<td><cf_cboTESid onchange="this.form.submit();"></td>
		</tr>
		<tr> 
			<td  valign="baseline" width="20" >&nbsp;</td>
			<td  valign="baseline" width="180" >Per&iacute;odo</td>
			<td  valign="baseline" width="90" >Mes</td>
			<td  valign="baseline" width="260">Fecha</td>
			<td  valign="baseline" >Descripci&oacute;n</td>			
			<td  valign="baseline" colspan="2">Usuario</td>
		</tr>
		
		<tr> 
			<td >&nbsp;</td>
			<td > 
				<select name="fETperiodo" >
					<option value="all">Todos</option>
					<cfoutput query="rsPeriodos"> 
						<option value="#rsPeriodos.ETperiodo#" >#rsPeriodos.ETperiodo#</option>
					</cfoutput>
				</select>
			</td>
			
			<td > 
				<select name="fETmes" >
					<option value="all">Todos</option>
					<cfoutput query="rsMes"> 
						<option value="#rsMes.ETmes#" >#meses[rsMes.ETmes]#</option>
					</cfoutput>
				</select>
			</td>

			<td>
				<cf_sifcalendario form="ftransferencias" name="fETfecha">
			</td>

			<td > <input type="text" name="fETdescripcion" size="30" maxlength="255" value="" onFocus="javascript: this.select();"></td>

			<td > 
				<select name="fUsuario" >
					<option value="all">Todos</option>
					<cfoutput query="rsUsuarios"> 
						<option value="#ETusuario#" >#ETusuario#</option>
					</cfoutput>
				</select>
			</td>
			<td ><input type="submit" name="btnFiltro"  value="Filtrar"></td>
		</tr>
	</table>
</form>
