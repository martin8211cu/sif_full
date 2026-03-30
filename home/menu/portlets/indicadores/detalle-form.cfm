<cfparam name="url.rango"    default="T"><!--- T,Y,M,W,O --->
<cfparam name="url.rangoDet" default="M"><!--- month.  valid = Y,Q,M,W,D --->
<cfparam name="url.org"      default="C"><!--- C,E,O,D,F --->
<cfparam name="url.orgDet"   default="D"><!--- depto.  valid = E,O,D,F   --->

<!---
	FIJAR rangoDet según rango, por ahora, mientras veo cómo evito que se llene mucho
--->
<cfset url.rangoDet = ListGetAt('Y;M;W;D;M', ListFind('T,Y,M,W,O', url.rango), ';')>
<cfset url.orgDet   = ListGetAt('E;O;D;O;F', ListFind('C,E,O,D,F', url.org), ';')>

<cfset rango_sql = ListGetAt('iv.periodo;iv.trimestre;iv.mes;datepart(wk,iv.fecha);iv.fecha', ListFind('Y,Q,M,W,D', url.rangoDet), ';')>
<cfset org_sql   = ListGetAt('iv.Ecodigo;iv.Ocodigo;iv.Dcodigo;iv.CFcodigo', ListFind('E,O,D,F', url.orgDet), ';')>

<cfset rango_name = ListGetAt('Periodo;Trimestre;Mes;Semana;Dia', ListFind('Y,Q,M,W,D', url.rangoDet), ';')>
<cfset org_name   = ListGetAt('Empresa;Oficina;Departamento;Centro Funcional', ListFind('E,O,D,F', url.orgDet), ';')>

<cfquery datasource="asp" name="datos_indicador">
	select i.indicador, i.nombre_indicador, coalesce (i.filtro_tiempo, 0) as filtro_tiempo,
		iu.Ocodigo, iu.Dcodigo, iu.CFid, i.descripcion_funcional, i.es_diario
	from IndicadorUsuario iu
		join Indicador i
			on iu.indicador = i.indicador
	where iu.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and i.indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.indicador#">
</cfquery>
<cfif datos_indicador.RecordCount Is 0>
	<cfquery datasource="asp" name="datos_indicador">
		select i.indicador, i.nombre_indicador, coalesce (i.filtro_tiempo, 0) as filtro_tiempo,
			null as Ocodigo, null as Dcodigo, null as CFid, i.descripcion_funcional
		from Indicador i
		where i.indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.indicador#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="empresa">
	select Ecodigo, Edescripcion from Empresas
</cfquery>
<cfif IsDefined('url.org_ecodigo')>
	<cfquery datasource="#session.dsn#" name="query_oficinas">
		select Ocodigo, Odescripcion
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.org_ecodigo#">
		order by Odescripcion
	</cfquery>
	<cfquery datasource="#session.dsn#" name="query_deptos">
		select Dcodigo, Ddescripcion
		from Departamentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.org_ecodigo#">
		order by Ddescripcion
	</cfquery>
	<cfquery datasource="#session.dsn#" name="query_funcional">
		select CFid as Fid, CFdescripcion as Fdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.org_ecodigo#">
		order by Fdescripcion
	</cfquery>
</cfif>

<cfset hoy = Now()>
<cfset hoy = CreateDate (Year (hoy), Month (hoy), Day (hoy) )  >

<cfif datos_indicador.es_diario>
	<!--- igual que en IndicadorCalc.cfc --->
	<cfset divide_diario =  " ">
<cfelse>
	<cfset divide_diario =  "/ count(distinct fecha) ">
</cfif>
<cfset args_initially_shown = false>
<cfquery datasource="#session.dsn#" name="valores">
	select
		#rango_sql# as v_rango,
		#org_sql#   as v_org,
		convert (int , sum (iv.valor) # divide_diario # ) as valor,
		convert (int , sum (iv.total) # divide_diario #) as total
	from IndicadorValor iv
	where iv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and iv.indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.indicador#">
	<cfif     (url.org Is 'F')>
		<cfset args_initially_shown = true>
		and iv.CFid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.org_fid#">
	<cfelseif (url.org Is 'D')>
		<cfset args_initially_shown = true>
		and iv.Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.org_dcodigo#">
	<cfelseif (url.org Is 'O')>
		<cfset args_initially_shown = true>
		and iv.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.org_ocodigo#">
	<cfelseif (url.org Is 'E')>
		<cfset args_initially_shown = true>
		and iv.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.org_ecodigo#">
	</cfif>
	<cfif     (url.rango Is 'Y')>
		<cfset args_initially_shown = true>
		and iv.periodo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.rango_y#">
	<cfelseif (url.rango Is 'Q')>
		<cfset args_initially_shown = true>
		and iv.periodo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.rango_qy#">
		and iv.trimestre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.rango_qq#">
	<cfelseif (url.rango Is 'M')>
		<cfset args_initially_shown = true>
		and iv.periodo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.rango_my#">
		and iv.mes       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.rango_mm#">
	<cfelseif (url.rango Is 'W')>
		<cfset args_initially_shown = true>
		and iv.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.rango_w)#">
		                 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 7, LSParseDateTime(url.rango_w))#">
	<cfelseif (url.rango Is 'O')>
		<cfset args_initially_shown = true>
		and iv.fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.rango_o1)#">
		                 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.rango_o2)#">
	</cfif>
	
	group by #rango_sql#, #org_sql#
</cfquery>


<cf_web_portlet titulo="#datos_indicador.nombre_indicador#" skin="portlet" width="700" >         


<script type="text/javascript">
<!--
	function ind_obj(x){return document.all?document.all[x]:document.getElementById(x)};
	function rango_change(valor_nuevo){
		ind_obj('rangoT').style.display = (valor_nuevo == 'T') ? 'block' : 'none';
		ind_obj('rangoY').style.display = (valor_nuevo == 'Y') ? 'block' : 'none';
		ind_obj('rangoM').style.display = (valor_nuevo == 'M') ? 'block' : 'none';
		ind_obj('rangoW').style.display = (valor_nuevo == 'W') ? 'block' : 'none';
		ind_obj('rangoO').style.display = (valor_nuevo == 'O') ? 'block' : 'none';
		if (valor_nuevo == 'T') {
			document.formargs.rangoDet.value = 'Y';
		} else if (valor_nuevo == 'Y') {
			document.formargs.rangoDet.value = 'M';
		} else if (valor_nuevo == 'M') {
			document.formargs.rangoDet.value = 'W';
		} else if (valor_nuevo == 'W') {
			document.formargs.rangoDet.value = 'D';
		} else if (valor_nuevo == 'O') {
			document.formargs.rangoDet.value = 'M';
		} else {
			document.formargs.rangoDet.value = '';
		}
	}
	
	function org_change(valor_nuevo){
		ind_obj('orgC').style.display = (valor_nuevo == 'C') ? 'block' : 'none';
		ind_obj('orgE').style.display = (valor_nuevo == 'E') ? 'block' : 'none';
		ind_obj('orgO').style.display = (valor_nuevo == 'O') ? 'block' : 'none';
		ind_obj('orgD').style.display = (valor_nuevo == 'D') ? 'block' : 'none';
		ind_obj('orgF').style.display = (valor_nuevo == 'F') ? 'block' : 'none';
		if (valor_nuevo == 'C') {
			document.formargs.orgDet.value = 'E';
		} else if (valor_nuevo == 'E') {
			document.formargs.orgDet.value = 'O';
		} else if (valor_nuevo == 'O') {
			document.formargs.orgDet.value = 'D';
		} else if (valor_nuevo == 'D') {
			document.formargs.orgDet.value = 'O';
		} else if (valor_nuevo == 'F') {
			document.formargs.orgDet.value = 'F';
		} else {
			document.formargs.orgDet.value = '';
		}
	}
	
	function show_args(){
		if (ind_obj('divargs').style.display=='none'){
			ind_obj('divargs').style.display='block';
			ind_obj('argsimg').src = 'dn-arr.gif';
		} else {
			ind_obj('divargs').style.display='none';
			ind_obj('argsimg').src = 'lt-arr.gif';
		}
	}
//-->
</script>



<cfoutput>
<table width="700" border="0" align="center">
  <tr>
    <td width="15">&nbsp;</td>
    <td width="51">&nbsp;</td>
    <td width="550">&nbsp;</td>
    <td width="40">&nbsp;</td>
    <td width="22">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td rowspan="2"><a href="../../portal.cfm"><img src="back-arrow2.jpg" width="39" height="34" border="0"></a></td>
    <td><em><strong>#datos_indicador.nombre_indicador#</strong></em></td>
    <td rowspan="2"><a href="javascript:show_args()"><img src="<cfif args_initially_shown>dn-arr.gif<cfelse>lt-arr.gif</cfif>" name="argsimg" width="40" height="40" border="0" id="argsimg"></a></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>#datos_indicador.descripcion_funcional#</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><div id="divargs"  style="display:<cfif args_initially_shown>block<cfelse>none</cfif>; width:490px" >
<form name="formargs" method="get" action="detalle.cfm">
<input type="hidden" name="indicador" value="#HTMLEditFormat(Trim(url.indicador))#">
  <table width="483" border="0" align="center">
    <tr>
      <td width="9" height="22">&nbsp;</td>
      <td width="86">Fechas </td>
      <td width="143"><select name="rango" onChange="rango_change(this.value)" style="width:140px">
        <option value="T" <cfif url.rango is 'T'>selected</cfif>>Todo</option>
        <option value="Y" <cfif url.rango is 'Y'>selected</cfif>>A&ntilde;o</option>
        <option value="M" <cfif url.rango is 'M'>selected</cfif>>Mes</option>
        <option value="W" <cfif url.rango is 'W'>selected</cfif>>Semana</option>
        <option value="O" <cfif url.rango is 'O'>selected</cfif>>Otro...</option>
      </select></td>
      <td width="211" nowrap><div id="rangoT" style="<cfif url.rango neq 'T'>display:none;</cfif>">&nbsp;</div>
	  <div id="rangoY" style="<cfif url.rango neq 'Y'>display:none;</cfif>"><select name="rango_y" id="rango_y"><cfloop from="#Year(Now())-20#" to="#Year(Now())+5#" index="yr">
	  <option value="#yr#" <cfif yr+1 is Year(Now())>selected</cfif>>#yr#</option></cfloop></select></div>
	  <div id="rangoM" style="<cfif url.rango neq 'M'>display:none;</cfif>"><select name="rango_mm" id="rango_mm" >
	  	<option value="1" selected>Enero</option>
	  	<option value="2">Febrero</option>
	  	<option value="3">Marzo</option>
	  	<option value="4">Abril</option>
	  	<option value="5">Mayo</option>
	  	<option value="6">Junio</option>
	  	<option value="7">Julio</option>
	  	<option value="8">Agosto</option>
	  	<option value="9">Septiembre</option>
	  	<option value="10">Octubre</option>
	  	<option value="11">Noviembre</option>
	  	<option value="12">Diciembre</option>
	  </select>
	    <select name="rango_my" id="rango_my">
	      <cfloop from="#Year(Now())-20#" to="#Year(Now())+5#" index="yr">
            <option value="#yr#" <cfif yr+1 is Year(Now())>selected</cfif>>#yr#</option>
	        </cfloop>
	      </select>
	  </div>
	  <div id="rangoW" style="<cfif url.rango neq 'W'>display:none;</cfif>"><input name="rango_w" id="rango_w" type="text" value="19/10/2005" size="10" maxlength="10">
	  </div>
	  <div id="rangoO" style="<cfif url.rango neq 'O'>display:none;</cfif>">
	    <input name="rango_o1" type="text" value="19/09/2004" size="10" maxlength="10">
	    -
	    <input name="rango_o2" type="text" value="25/09/2004" size="10" maxlength="10">
	  </div></td>
      <td width="12">&nbsp;</td>
    </tr>
    <tr>
      <td height="22">&nbsp;</td>
      <td>Desglosar</td>
      <td><select name="rangoDet" style="width:140px">
        <option value="Y" <cfif url.rangoDet is 'Y'>selected</cfif>>Anual</option>
        <option value="Q" <cfif url.rangoDet is 'Q'>selected</cfif>>Trimestral</option>
        <option value="M" <cfif url.rangoDet is 'M'>selected</cfif>>Mensual</option>
        <option value="W" <cfif url.rangoDet is 'W'>selected</cfif>>Semanal</option>
        <option value="D" <cfif url.rangoDet is 'D'>selected</cfif>>Diario</option>
      </select></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td height="22">&nbsp;</td>
      <td>Organizaci&oacute;n </td>
      <td><select name="org" onChange="org_change(this.value)" style="width:140px">
        <option value="C" <cfif url.org is 'C'>selected</cfif>>Corporativo</option>
        <option value="E" <cfif url.org is 'E'>selected</cfif>>Empresa</option>
        <option value="O" <cfif url.org is 'O'>selected</cfif>>Oficina</option>
        <option value="D" <cfif url.org is 'D'>selected</cfif>>Departamento</option>
        <option value="F" <cfif url.org is 'F'>selected</cfif>>Centro Funcional</option>
      </select></td>
      <td>
	  <div id="orgC" style="<cfif url.org neq 'C'>display:none;</cfif>">&nbsp;</div>
	  <div id="orgE" style="<cfif url.org neq 'E'>display:none;</cfif>">
	  <select name="org_ecodigo" id="org_ecodigo" style="width:210px">
	  <cfloop query="empresa">
        <option value="#HTMLEditFormat(Ecodigo)#" >#HTMLEditFormat(Edescripcion)#</option>
		</cfloop>
      </select></div>
	  <div id="orgO" style="<cfif url.org neq 'O'>display:none;</cfif>">
	  <select name="org_ocodigo" id="org_ocodigo" style="width:210px">
		  <cfif IsDefined('query_oficinas')>
			<cfloop query="query_oficinas">
				<option value="#HTMLEditFormat(Ocodigo)#" <cfif IsDefined('url.org_ocodigo') and (url.org_ocodigo EQ Ocodigo)>selected</cfif> >#HTMLEditFormat(Odescripcion)#</option>
			</cfloop>
		  </cfif>
      </select></div>
	  <div id="orgD" style="<cfif url.org neq 'D'>display:none;</cfif>">
	  <select name="org_dcodigo" id="org_dcodigo" style="width:210px">
		  <cfif IsDefined('query_deptos')>
			<cfloop query="query_deptos">
				<option value="#HTMLEditFormat(Dcodigo)#" <cfif IsDefined('url.org_dcodigo') and (url.org_dcodigo EQ Dcodigo)>selected</cfif> >#HTMLEditFormat(Ddescripcion)#</option>
			</cfloop>
		  </cfif>
      </select></div>
	  <div id="orgF" style="<cfif url.org neq 'F'>display:none;</cfif>">
	  <select name="org_fid" id="org_fid" style="width:210px">
		  <cfif IsDefined('query_funcional')>
			<cfloop query="query_funcional">
				<option value="#HTMLEditFormat(Fid)#" <cfif IsDefined('url.org_fid') and (url.org_fid EQ Fid)>selected</cfif> >#HTMLEditFormat(Fdescripcion)#</option>
			</cfloop>
		  </cfif>
      </select></div>
	  </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td height="22">&nbsp;</td>
      <td>Desglosar</td>
      <td><select name="orgDet" style="width:140px">
        <option value="E" <cfif url.orgDet is 'E'>selected</cfif>>Empresa</option>
        <option value="O" <cfif url.orgDet is 'O'>selected</cfif>>Oficina</option>
        <option value="D" <cfif url.orgDet is 'D'>selected</cfif>>Departamento</option>
        <option value="F" <cfif url.orgDet is 'F'>selected</cfif>>Centro Funcional</option>
      </select></td>
      <td align="right">
        <input type="submit" name="Submit" value="Actualizar &gt;&gt;"></td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</div></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

</cfoutput>


<table width="700" border="0" align="center">
  <tr>
    <td width="15">&nbsp;</td>
    <td width="276">&nbsp;</td>
    <td width="15">&nbsp;</td>
    <td width="349">&nbsp;</td>
    <td width="23">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">
	<cfset churl = "detalle.cfm?indicador=" & url.indicador & "&rango=" & url.rangoDet>
	<cfif url.rangoDet is 'Y'>
		<cfset churl = churl & "&rango_y=$ITEMLABEL$">
	<cfelseif url.rangoDet is 'M'>
		<cfset churl = churl & "&rango_my=" & url.rango_y & "&rango_mm=$ITEMLABEL$">
	<cfelse>
		<cfset churl = "">
	</cfif>
		<cfchart format="flash" showxgridlines="no" showygridlines="yes" showborder="no" 
			fontbold="no" fontitalic="no" show3d="yes" rotated="no"
			sortxaxis="no" showlegend="yes" showmarkers="no" xaxistitle="#rango_name#" url="#churl#">
		
			<cfchartseries type="bar" query="valores" itemcolumn="v_rango" valuecolumn="valor" serieslabel="Valor" seriescolor="##0099FF">
			<cfchartseries type="bar" query="valores" itemcolumn="v_rango" valuecolumn="total" serieslabel="Total" seriescolor="##00CC66">
		
		</cfchart>
		
	
    </td>
    <td valign="top">&nbsp;</td>
    <td valign="top">
		<table width="297" bgcolor="#CCCCCC" cellpadding="2" cellspacing="2">
	<cfoutput>
			<tr><td width="51"><strong>#org_name#</strong></td>
			<td width="66"><strong>#rango_name#</strong></td>
			<td width="46" align="right"><strong>Valor</strong></td>
			<td width="42" align="right"><strong>Total</strong></td>
			<td width="58" align="right"><strong>%</strong></td>
			</tr>
		</cfoutput>
		<cfoutput query="valores">
			<tr><td bgcolor="##FFFFFF">#v_org#</td><td bgcolor="##FFFFFF">#v_rango#</td>
				<td align="right" bgcolor="##FFFFFF">#NumberFormat(valor)#</td>
				<td align="right" bgcolor="##FFFFFF">#NumberFormat(total)#</td>
				<td align="right" bgcolor="##FFFFFF">
					<cfif total neq 0>#NumberFormat(valor/total*100,'0.00')# %</cfif></td>
			</tr>
		</cfoutput>
	  </table>
	</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>


</cf_web_portlet>
