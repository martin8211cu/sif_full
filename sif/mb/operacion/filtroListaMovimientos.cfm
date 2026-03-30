
<!-- Consultas -->
<!-- 1. Combo Tipos de Transaccion -->
<cfquery datasource="#Session.DSN#" name="rsTipo">
	select distinct bt.BTid, BTdescripcion 
	from BTransacciones bt, EMovimientos em
	where bt.Ecodigo=em.Ecodigo
	  and bt.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
	  and bt.BTid=em.BTid
	order by BTdescripcion  
</cfquery>
<!-- 2. Combo usuario -->
<cfquery datasource="#Session.DSN#" name="rsUsuario">
    select distinct EMusuario 
	from EMovimientos 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by EMusuario
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
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>

<body onLoad="MM_preloadImages('/cfmx/sif/imagenes/DATE_D.gif')">


<form style="margin: 0" action="listaMovimientos.cfm" name="fmovimientos" method="post" >
	  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr> 
		  <td width="8">&nbsp;</td>
		  <td valign="baseline" width="145">Documento</td>
		  <td valign="baseline" width="150">Descripci&oacute;n</td>
		  <td width="8">&nbsp;</td>
		  <td valign="baseline">Transacci&oacute;n</td>
		  <td width="108">&nbsp;</td>
		  <td >Fecha</td>
		  <td colspan="5" valign="baseline">Usuario</td>
		</tr>
		<tr> 
		  <td width="8">&nbsp;</td>
		  <td width="145"> <input type="text" name="fEMdocumento" size="15" maxlength="20" value="" style=" text-transform:uppercase;" ></td>
		  <td> <input type="text" name="fEMdescripcion" size="30" maxlength="50" value="" style=" text-transform:uppercase;" ></td>
		  <td width="8">&nbsp;</td>
		  <td> <select name="fBTid" >
			  <option value="all">Todos</option>
			  <cfoutput query="rsTipo"> 
				<option value="#rsTipo.BTid#" >#rsTipo.BTdescripcion#</option>
			  </cfoutput> </select> </td>
		  <td width="108">&nbsp;</td>
		  <td><cf_sifcalendario form="fmovimientos" name="fEMfecha"></td>

		  <td> <select name="fUsuario" >
			  <option value="all">Todos</option>
			  <cfoutput query="rsUsuario"> 
				<option value="#rsUsuario.EMusuario#" >#rsUsuario.EMusuario#</option>
			  </cfoutput> </select> </td>
		  <td> <input type="submit" name="btnFiltro"  value="Filtrar"></td>
		  <td> <input type="submit" name="btnNuevo"  value="Nuevo"></td>
		  <td> <input type="submit" name="btnAplicar"  value="Aplicar"></td>
		  <td> <input type="submit" name="btnImprimir"  value="Imprimir"></td>
		</tr>
	  </table>
</form>
