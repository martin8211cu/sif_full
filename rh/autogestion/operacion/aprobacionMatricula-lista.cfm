<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<form name="form1" action="aprobacionMatricula-sql.cfm" method="post" onSubmit="return valida();">
<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr><td colspan="6"><strong>La siguiente lista muestra los colaboradores que desean matricular algún curso</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td nowrap="nowrap">Empleado: <cf_rhempleados></td>
			<td width="20%">Estado:
				<select name="opestado" id="opestado">
					<option value="0" <cfif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 0>selected="selected"</cfif>>En proceso</option>
					<option value="1" <cfif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 1>selected="selected"</cfif>>Aprobados por jefe</option>
					<option value="2" <cfif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 2>selected="selected"</cfif>>Aprobados en RH</option>                   
				</select>
			</td>
			<td nowrap="nowrap">Fecha Inicial:<cf_sifcalendario name="fIni"></td>
			<td nowrap="nowrap">Fecha Final:<cf_sifcalendario name="fFin"></td>
			<td>
				<input type="button" value="Filtrar" name="btnFiltrar" onclick="fnClic()" />
			</td>
		</tr>
	
		<tr><td colspan="6">&nbsp;</td></tr>
			<cf_dbfunction name="OP_concat" returnvariable="_Cat">
			<cf_dbfunction name="to_char"	args="e.RHECid"         returnvariable="RHECid">
			<!---<cfset coma="','">--->
			<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
			<cfset EL	= replace(EL,"'","''","ALL")>
			<cfset EL	= replace(EL,"AAAA","' #_Cat# #RHECid# #_Cat#'","ALL")>
			
			<cfquery name="rsEmp" datasource="#session.dsn#">
				select e.RHECid,d.DEapellido1 #LvarCNCT#' '#LvarCNCT#d.DEapellido2#LvarCNCT#' '#LvarCNCT#d.DEnombre as nombre,
				h.RHCcodigo #LvarCNCT#'-' #LvarCNCT#h.RHCnombre as Curso,d.DEid,e.RHCid,
				<cfif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 1>
				'' as eli,
				<cfelseif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 2>
				'' as eli,
				<cfelse>
				'#PreserveSingleQuotes(EL)#' as eli,
				</cfif>
				' ' as espacio,
				'-' as guion,
				RHCfdesde,RHCfhasta,
				duracion,lugar,<cf_dbfunction name="date_format" args="horaini,HH:MI"> #LvarCNCT#'-'#LvarCNCT# <cf_dbfunction name="date_format"	args="horafin,HH:MI"> as horario
				from LineaTiempo l
					inner join RHPlazas p
					on l.RHPid=p.RHPid
					and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between l.LTdesde and l.LThasta
					inner join RHEmpleadoCurso e
					inner join RHCursos h
					on h.RHCid=e.RHCid					
					inner join DatosEmpleado d
					on d.DEid=e.DEid
				on e.DEid=l.DEid
				where  l.Ecodigo=1
				
				<cfif isdefined ('form.DEid') and len(trim(form.DEid)) gt 0>
					and e.DEid=#form.DEid#
				</cfif>
				<cfif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 1>
				and e.RHECestado=30
				<cfelseif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 2>
				and e.RHECestado=50
				<cfelse>
				and h.RHCfhasta >  #now()#
				and e.RHECestado=10
				</cfif>
				<cfif isdefined ('form.fIni') and len(trim(form.fIni)) gt 0>
					and RHCfdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fIni#">
				</cfif>
				<cfif isdefined ('form.fFin') and len(trim(form.fFin)) gt 0>
					and RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fFin#">
				</cfif>
				order by Curso,RHECid,RHCfdesde,RHCfhasta	
			</cfquery>
			<!--- and l.DEid in (#lista_deid#) --->
			<cfif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 1>
				<cfset LvarChk='n'>
			<cfelseif isdefined('form.opestado') and len(trim(form.opestado)) gt 0 and form.opestado eq 2>
				<cfset LvarChk='n'>
			<cfelse>
				<cfset LvarChk='s'>
			</cfif>
			<tr><td colspan="6">
			<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
				query="#rsEmp#"
				columnas="RHCid,RHCcodigo,nombre,Curso,RHCfdesde,RHCfhasta,duracion,horario,lugar,eli"
				desplegar="nombre,Curso,RHCfdesde,RHCfhasta,duracion,horario,lugar,eli"
				etiquetas="Nombre,Curso,Desde,Hasta,Duración,Horario,Lugar,Eliminar"
				formatos="S,S,D,D,S,S,S,S"
				align="left,left,left,left,center,right,left,left"
				ira="aprobacionMatricula.cfm"
				form_method="get"
				keys="RHECid"
				filtrar_automatico="true"
				mostrar_filtro="false"	
				MaxRows="25"
				checkboxes="#LvarChk#"
				incluyeForm="false"
				showLink="false"
				Cortes="Curso"/>			
			</td></tr>
			<tr><td colspan="6"><cf_botones names="Aprobar" values="Aprobar"></td></tr>
	</table>
	<input type="submit"  value="Lista1" name="AgregarDt" id="AgregarDet" style="display:none"/>
	<input type="submit"  value="Lista2" name="BorrarDet" id="BorrarDet" style="display:none"/>
</cfoutput>
</form>

<script language="javascript">
	function valida(){
		if (!btnSelected('btnFiltrar',document.form1)){
		var form = document.form1;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) alert('Debe seleccionar al menos un registro');
		return result;
	}}
	function borraDet(RHECid){			
			var PARAM  = "/cfmx/rh/autogestion/operacion/aprobacion_justificacion.cfm?RHECid="+ RHECid+"&formu="+'form1' ;
			open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=180')  
		
<!---			document.form1.BorrarDet.value = RHECid;
			document.form1.BorrarDet.click();--->		
	}
	
	function fnClic(){
		document.form1.action = 'apruebaMatricula.cfm';
		document.form1.submit()
	}
</script>
