<cf_templateheader title="Selección de Bitácora por empresa">
<cf_web_portlet_start titulo="Selección de Bitácora por Empresa">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cfquery datasource="asp" name="lista">
	select ce.CEcodigo, ce.CEnombre, e.Ecodigo, e.Enombre, b.PBinactivo, c.Ccache
	from Empresa e
		join CuentaEmpresarial ce
			on ce.CEcodigo = e.CEcodigo
		left join PBitacoraEmp b
			on b.Ecodigo = e.Ecodigo
		join Caches c
			on c.Cid = e.Cid
	order by ce.CEnombre, ce.CEcodigo, e.Enombre, e.Ecodigo
</cfquery>


<cfquery datasource="asp" name="lista_regenerar">
	select distinct c.Ccache, b.PBtabla
	from Caches c
		right join Empresa e
			on c.Cid = e.Cid,
		PBitacora b
	where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
	  and not exists (
			select 1 from PBitacoraTrg t
			where t.cache = c.Ccache
			  and t.PBtabla = b.PBtabla
			  and t.regenerar = 0 
			)
</cfquery>


<table border="0" width="980">
  <tr><td width="650" valign="top">

<cfoutput query="lista" group="CEcodigo">
<table border="0" cellspacing="0" cellpadding="2" width="650" style="cursor:pointer ">
<tr class="listaCorte"><td width="19" onClick="showtree(#CEcodigo#)" >
<img src="16x16_flecha_right.png" name="arrow#CEcodigo#" width="16" height="16" border="0"></td>
<td width="309" onClick="showtree(#CEcodigo#)" ><strong>#HTMLEditFormat(CEnombre)#</strong></td>
<td width="310"><form action="PBitacoraEmp-apply.cfm" method="post" style="margin:0"> 
	<input type="hidden" name="CEcodigo" value="#lista.CEcodigo#">
	<input type="submit" name="activar_todo" value="Activar todos">
	<input type="submit" name="inactivar_todo" value="Inactivar todos">
</form></td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="2" id="table#CEcodigo#" width="650" style="xdisplay:none">
<cfoutput>
<tr id="therow#CurrentRow#" class="<cfif CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"><td width="40">&nbsp;</td>
<td width="288">#HTMLEditFormat(Enombre)# - <em>#HTMLEditFormat(Ccache)#</em></td>
<td width="310"><form action="PBitacoraEmp-apply.cfm" method="post" style="margin:0">
<input type="hidden" name="Ecodigo" value="#lista.Ecodigo#">
<input type="radio" name="activo#Ecodigo#" id="activo1#Ecodigo#" onChange="this.form.submit()" value="1" <cfif PBinactivo neq 1>checked</cfif> ><label for="activo1#Ecodigo#">Activo</label>
<input type="radio" name="activo#Ecodigo#" id="activo0#Ecodigo#" onChange="this.form.submit()" value="0" <cfif PBinactivo  eq 1>checked</cfif> ><label for="activo0#Ecodigo#">Inactivo</label>

</form></td>
</tr>
</cfoutput>
<tr ><td width="40">&nbsp;</td>
<td colspan="2">&nbsp;</td></tr>
</table>
</cfoutput>

</td><td width="120">&nbsp;</td><td width="200" align="right" valign="top">

<cf_web_portlet_start titulo="Otras Operaciones">
<form action="PBitacoraEmp-apply.cfm" method="post" name="glb"> <input type="hidden" name="activo" value=""><input type="hidden" name="glb" value="1">
<table width="80%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" colspan="3">Aplicar para TODAS las empresas 
	de TODAS las Cuentas Empresariales</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top"><img src="16x16_flecha_right.png" width="16" height="16" border="0"></td>
    <td>&nbsp;</td>
    <td valign="top"><a href="#" onClick="document.glb.activo.value = 1;document.glb.submit()">Activar bit&aacute;cora</a></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top"><img src="16x16_flecha_right.png" width="16" height="16" border="0"></td>
    <td>&nbsp;</td>
    <td valign="top"><a href="#" onClick="if (confirm('Está a punto de desactivar la bitácora para todas las empresas de todas las cuentas empresariales. Confirme si esto es lo que desea realizar.')){document.glb.activo.value = 0;document.glb.submit();}">Inactivar bit&aacute;cora</a></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top"><img src="16x16_flecha_right.png" width="16" height="16" border="0"></td>
    <td>&nbsp;</td>
    <td valign="top"><a href="../../operacion/trigger/index.cfm" >Generar triggers...</a></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
	
	
    <td valign="top"><cfif lista_regenerar.RecordCount>
		<cfoutput><a href="../../operacion/trigger/regenerar.cfm" target="_blank">(#lista_regenerar.RecordCount# tablas) </a></cfoutput>
	<cfelse>
		Todos los triggers est&aacute;n al d&iacute;a
	</cfif></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
 
</form>
<cf_web_portlet_end>
</td></tr></table>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
MM_preloadImages('16x16_flecha_down.png');
function showtree(id){
	if (!(tbl=MM_findObj('table'+id))) return;
	if(tbl.style.display=='none'){
		tbl.style.display = 'block';
		MM_findObj('arrow'+id).src='16x16_flecha_down.gif';
	} else {
		tbl.style.display = 'none';
		MM_findObj('arrow'+id).src='16x16_flecha_right.gif';
	}
	return;
}

//-->
</script>

<cf_web_portlet_end><cf_templatefooter> 