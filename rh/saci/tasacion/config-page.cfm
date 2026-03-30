<cf_templateheader title="Configurar tasador">

<cf_web_portlet_start titulo="Configurar tasador">

<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="hostname"/>

<table width="900" border="0" cellpadding="2" cellspacing="0">

    <tr>
      <td colspan="2" valign="top" >&nbsp;</td>
          </tr>
    <tr>
      <td colspan="2" valign="top" class="subTitulo">Procesos de tasación</td>
          </tr>  <tr>
    <td width="508" valign="top">
<cfinclude template="config-page-list.cfm">
	</td>
    <td width="384" valign="top" align="right">
	<div id="contenedor">&nbsp;</div>
	</td>
  </tr>
</table>
<cf_web_portlet_end> 

<script type="text/javascript">
row_selected = false;
function iniciar_servicio(servicio) {
	window.open('config.cfm?action=run&servicio=' + escape(servicio), 'proceso');
	window.setTimeout('location.reload(true)', 500);
}
function detener_servicio(servicio) {
	window.open('config.cfm?action=stop&servicio=' + escape(servicio), 'proceso');
}
function reload_lista(){
	window.open('config.cfm?lista=yes', 'proceso');
}
function o(d,s){return d.all ? d.all[s] : d.getElementById(s);}
function cp(src,dstname){
	if(!dstname)dstname='contenedor';
	o(document, dstname).innerHTML = src.innerHTML;
}
function loading(){
	// o(document, 'contenedor').innerHTML = 'Loading...';
}

function mostrar_servicio(servicio) {
	loading();
	window.open('config.cfm?servicio=' + escape(servicio), 'proceso');
}
function mostrar_host(hostname) {
	loading();
	window.open('config.cfm?hostname=' + escape(hostname), 'proceso');
}

function svc_mouseover(servicio,tr){
	if (!row_selected) {
		//mostrar_servicio(servicio);
	}
	if(!tr.oldClassName)tr.oldClassName = tr.className;
	tr.className = "listaParSel";
}
function host_mouseover(hostname,tr){
	if (!row_selected) {
		//mostrar_host(hostname);
	}
	if(!tr.oldClassName)tr.oldClassName = tr.className;
	tr.className = "listaParSel";
}


function svc_mouseout(tr){
	if (tr != row_selected && tr.oldClassName) {
		tr.className = tr.oldClassName;
	}
}
host_mouseout=svc_mouseout;

function svc_click(servicio,tr){
	row_anterior = row_selected;
	row_selected = tr;
	svc_mouseout(row_anterior);
	mostrar_servicio(servicio);
}
function host_click(hostname,tr){
	row_anterior = row_selected;
	row_selected = tr;
	svc_mouseout(row_anterior);
	mostrar_host(hostname);
}

function host_add(){
	if(row_selected){
		row_selected.className = row_selected.oldClassName;
		row_selected.className="listaPar";
	}
	row_selected=true;
	mostrar_host('');
}
function validar_host(f){
	f.btnGuardar.disabled='true';
	return true;
}
</script>

<iframe name="proceso" id="proceso" width="900" height="400" frameborder="0" style="display:none;"></iframe>
<cf_templatefooter>

