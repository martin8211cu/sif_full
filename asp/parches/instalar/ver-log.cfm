<cfparam name="url.from" default="">
<cfparam name="url.sev" default="0">
<cfparam name="url.s" default="">
<cfparam name="url.num_tarea" default="">

<cfquery datasource="asp" name="APTareas">
	select num_tarea,tipo,datasource,ruta
	from APTareas
	where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	order by num_tarea
</cfquery>

<form action="<cfoutput>#  CGI.SCRIPT_NAME #</cfoutput>" style="width:551px">
		<table width="551" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="79">Tarea</td>
    <td width="458"><select name="num_tarea" style="width:400px">
	<option value="">Ver todo</option>
	<cfoutput query="APTareas" group="tipo">
	<optgroup label="# HTMLEditFormat( tipo ) #">
		<cfoutput>
			<option value="#APTareas.num_tarea#" <cfif url.num_tarea eq APTareas.num_tarea>selected</cfif>>
					# HTMLEditFormat( APTareas.ruta ) # -
					# HTMLEditFormat( APTareas.datasource ) #			</option>
		</cfoutput>	</optgroup>
	</cfoutput>
	</select></td>
    </tr>
  <tr>
    <td>Desde línea </td>
    <td><cfoutput><input type="text" name="from" value="# HTMLEditFormat(url.from) #" /></cfoutput></td>
    </tr>
  <tr>
    <td>Severidad</td>
    <td><select name="sev" onchange="this.form.submit()">
	<option value="-1" <cfif url.sev EQ -1>selected</cfif>>DEBUG</option>
	<option value="0" <cfif url.sev EQ 0>selected</cfif>>INFO</option>
	<option value="1" <cfif url.sev EQ 1>selected</cfif>>WARN</option>
	<option value="2" <cfif url.sev EQ 2>selected</cfif>>ERROR</option>
    </select></td>
    </tr>
  <tr>
    <td>Buscar</td>
    <td><cfoutput><input type="text" name="s" value="# HTMLEditFormat(url.s) #" /></cfoutput></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="actualizar" type="submit" class="btnFiltrar" value="Actualizar" />
	<cfif IsDefined('Request.continuar')>
	<cfoutput>
	<input name="continuar" type="button" class="btnSiguiente" value="Continuar" onclick="location.href='#JSStringFormat(Request.continuar)#'"/>
	</cfoutput></cfif>	</td>
    </tr>
</table>

</form>

<cfquery datasource="asp" name="msgs">
	select m.num_tarea, m.num_msg, m.fecha, m.nombre, m.severidad, m.msg_corto,
		t.tipo, t.ruta, t.datasource
	from APMensajes m
		left join APTareas t
			on t.instalacion = m.instalacion
			and t.num_tarea = m.num_tarea
	where m.instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	<cfif Len(url.num_tarea)>
	  and m.num_tarea = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.num_tarea#">
	</cfif>
	<cfif Len(url.from)>
	  and m.num_msg >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.from#">
	</cfif>
	<cfif Len(url.sev)>
	  and m.severidad >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.sev#">
	</cfif>
	<cfif Len(url.s)>
	  and lower(m.msg_corto) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%# LCase( url.s )#%">
	</cfif>
</cfquery>

<cfif msgs.RecordCount>

<table border="0" cellspacing="0" cellpadding="2" width="690">
	<cfoutput query="msgs" group="num_tarea">
  <tr class="listaCorte">
    <td colspan="5">Tarea #num_tarea#: # tipo # / # ruta # / # datasource #</td>
    </tr>
  <tr class="tituloListas">
    <td width="38">&nbsp;</td>
    <td width="82">Fecha</td>
    <td width="99">Objeto</td>
    <td width="57">Sev.</td>
    <td width="382">Mensaje</td>
  </tr><cfoutput>
  <cfif CurrentRow mod 2><cfset trclass='listaNon'><cfelse><cfset trclass='listaPar'></cfif>
  <tr class="#trclass#" onmouseover="this.className='#trclass#Sel';" onmouseout="this.className='#trclass#';" style="cursor:pointer">
    <td valign="top">#num_msg#</td>
    <td valign="top">#fecha#</td>
    <td valign="top">#nombre#</td>
    <td valign="top">
	<cfinvoke component="asp.parches.comp.misc" method="sev2sevname"
		severidad="#severidad#" returnvariable="sevname"/>
	# HTMLEditFormat( sevname )#</td>
    <td valign="top" onclick="ver_log_det(#NumberFormat(num_msg)#,this)">#msg_corto#</td>
  </tr></cfoutput>
	</cfoutput>
</table>
</cfif>
<iframe name="fr_ver_log_det" id="fr_ver_log_det" src="about:blank" frameborder="0" width="1" height="1" style="border:none"></iframe>
<div class="ayuda" id="floatinlayer" style="display:none;left:550px;width:300px;position:absolute;padding:7px">
</div>
<script type="text/javascript">
<!--
	function ver_log_det(n,target){
		if(document.msgtarget == target){
			hidemsg();
			document.msgtarget = null;
		} else {
			var fr = document.getElementById ? document.getElementById('fr_ver_log_det') : document.all.fr_ver_log_det;
			window.open('../ver-log-det.cfm?num_msg='+n, 'fr_ver_log_det', '', true);
		//	fr.src = '../ver-log-det.cfm?num_msg='+n;
			document.msgtarget = target;
			showmsg('<b>' + target.innerHTML + '</b><br>Obteniendo detalle del mensaje núm ' + n +'...');
		}
	}
	
	function showmsg(msgtext){
		with(document.getElementById('floatinlayer')){
			innerHTML = msgtext;
			style.top = mlm_top(document.msgtarget) + "px";
			style.left = mlm_left(document.msgtarget) - 320 + "px";
			style.display='block';
		}
	}
	function hidemsg(){
		document.getElementById('floatinlayer').style.display='none';
	}
//-->
</script>
