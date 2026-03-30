<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="Nomina" xmlfile="/rh/nomina/consultas/ListadoNomina.xml"	 returnvariable="vRelacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional"	 xmlfile="/rh/generales.xml" returnvariable="vCentro" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar"	 xmlfile="/rh/generales.xml" returnvariable="vConsultar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_No_se_encontraron_registros" default="No se encontraron registros"	 xmlfile="/rh/generales.xml" returnvariable="vNoRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde"	 xmlfile="/rh/generales.xml" returnvariable="vDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Hasta" default="Hasta"	 xmlfile="/rh/generales.xml" returnvariable="vHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"	 xmlfile="/rh/generales.xml" returnvariable="vDescripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Tipo_de_Nomina" default="Tipo de N&oacute;mina"	 xmlfile="/rh/generales.xml" returnvariable="vTipoNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EmpleadoDesde" default="Empleado Desde" returnvariable="LB_EmpleadoDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EmpleadoHasta" default="Empleado Hasta" returnvariable="LB_EmpleadoHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeEmpleados" default="Lista de Empleados" returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>


<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

		<cf_web_portlet_start border="true" titulo="Listado de N&oacute;mina" >
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
			<form style="margin:0" action="ListadoNomina.cfm" method="get" name="form1" id="form1" onsubmit="javascript: return validar();"  >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >

				<tr>
					<td align="right" valign="middle" width="30%"><strong><cf_translate key="LB_Consultar_por" xmlfile="/rh/nomina/consultas/ListadoNomina.xml">Consultar por</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="nominas" onchange="javascript: conlisRelacion(this.value);">
							<option value="A"><cf_translate key="LB_Relaciones_de_Calculo_abiertas" xmlfile="/rh/nomina/consultas/ListadoNomina.xml">Relaciones de C&aacute;lculo abiertas</cf_translate></option>
							<option value="H"><cf_translate key="LB_Relaciones_de_Calculo_cerradas" xmlfile="/rh/nomina/consultas/ListadoNomina.xml">Relaciones de C&aacute;lculo cerradas</cf_translate></option>
						</select>
					</td>
				</tr>

				<tr id="id_abiertas" >
					<td align="right" valign="middle"><strong>#vRelacion#:&nbsp;</strong></td>
					<td >
							<cf_conlis
								campos="atipo,ARCNid,ATcodigo,ATdescripcion,ARCDescripcion,ARCdesde,ARChasta"
								desplegables="N,N,N,N,S,N,N"
								modificables="N,N,N,N,N,N,N"
								size="0,0,5,25,50,12,12"
								title="Lista de Relaciones de C&aacute;lculo"
								tabla="RCalculoNomina a
										inner join TiposNomina b
										on b.Ecodigo=a.Ecodigo
										and b.Tcodigo=a.Tcodigo "
								columnas="	'Relaciones de C&aacute;lculo Abiertas' as tipodesc,
											'H' as Atipo,
											a.RCNid as ARCNid,
											a.Tcodigo as ATcodigo,
											b.Tdescripcion as ATdescripcion,
											{fn concat(a.Tcodigo,{fn concat(' - ',b.Tdescripcion)})} as Adescripcion,
											a.RCDescripcion as ARCDescripcion,
											a.RCdesde as ARCdesde,
											a.RChasta as ARChasta"
								filtro="a.Ecodigo=#session.Ecodigo#
										order by 1,4,7,8"
								desplegar="ARCDescripcion,ARCdesde,ARChasta"
								filtrar_por="RCDescripcion,RCdesde,RChasta"
								etiquetas="#vRelacion#,#vDesde#,#vHasta#"
								formatos=",S,D,D"
								align=",left,left,left"
								asignar="ARCNid,ARCDescripcion,atipo,ATcodigo"
								asignarformatos="S,S,S"
								showEmptyListMsg="true"
								EmptyListMsg="-- #vNoRegistros# --"
								tabindex="1"
								top="100"
								left="200"
								width="650"
								height="600"
								Cortes="tipodesc,Adescripcion"
								alt="tipo,#vRelacion#,#vRelacion#">
					</td>
				</tr>


				<tr id="id_cerradas" style="display:none;" >
					<td align="right" valign="middle"><strong>#vRelacion#:&nbsp;</strong></td>
					<td>
							<cf_conlis
								campos="htipo,HRCNid,HTcodigo,HTdescripcion,HRCDescripcion,HRCdesde,HRChasta"
								desplegables="N,N,N,N,S,N,N"
								modificables="N,N,N,N,N,N,N"
								size="0,0,5,25,50,12,12"
								title="Lista de Relaciones de C&aacute;lculo"
								tabla="HRCalculoNomina a
										inner join TiposNomina b
										on b.Ecodigo=a.Ecodigo
										and b.Tcodigo=a.Tcodigo "
								columnas="	'Relaciones de C&aacute;lculo Cerradas' as tipodesc,
											'H' as htipo,
											a.RCNid as HRCNid,
											a.Tcodigo as HTcodigo,
											{fn concat(a.Tcodigo,{fn concat(' - ',b.Tdescripcion)})} as Hdescripcion,
											b.Tdescripcion as HTdescripcion,
											a.RCDescripcion as HRCDescripcion,
											a.RCdesde as HRCdesde,
											a.RChasta as HRChasta"
								filtro="a.Ecodigo=#session.Ecodigo#
										order by 1,4,7,8"
								desplegar="HRCDescripcion,HRCdesde,HRChasta"
								filtrar_por="RCDescripcion,RCdesde,RChasta"
								etiquetas="#vRelacion#,#vDesde#,#vHasta#"
								formatos=",S,D,D"
								align=",left,left,left"
								asignar="HRCNid,HRCDescripcion,htipo,HTcodigo"
								asignarformatos="S,S,S,S"
								showEmptyListMsg="true"
								EmptyListMsg="-- #vNoRegistros# --"
								tabindex="1"
								top="100"
								left="200"
								width="650"
								height="600"
								Cortes="tipodesc,Hdescripcion"
								alt="tipo,#vRelacion#,#vRelacion#,#vRelacion#">
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle"><strong>#vCentro#:&nbsp;</strong></td>
					<td><cf_rhcfuncional></td>
				</tr>
				<tr>
					<td align="right" valign="middle"></td>
					<td>
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="1%"><input type="checkbox" name="dependencias" id="dependencias"/></td>
								<td width="100%" nowrap="nowrap"><label for="dependencias"><cf_translate key="LB_Incluir_Centros_Funcionales_dependientes" xmlfile="/rh/nomina/consultas/ListadoNomina.xml">Incluir Centros Funcionales dependientes</cf_translate></label></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="id_emplA1">
					<td align="right"><strong>#LB_EmpleadoDesde#:</strong>&nbsp;</td>
					<td>
						<cf_conlis
						   campos="DEid1,DEidentificacion1,Nombre1"
						   desplegables="N,S,S"
						   modificables="N,S,N"
						   size="0,20,40"
						   title="#LB_ListaDeEmpleados#"
						   tabla="RCalculoNomina rc,SalarioEmpleado se, DatosEmpleado de, LineaTiempo lt, RHPlazas p, CFuncional cf"
						   columnas="de.DEid as DEid1, de.DEidentificacion as DEidentificacion1, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as Nombre1"
						   filtro="rc.Ecodigo = #Session.Ecodigo#
						   			and rc.RCNid = $ARCNid,numeric$
						   			and rc.RCNid = se.RCNid
									and de.DEid = se.DEid
									and se.DEid = lt.DEid
									and lt.Ecodigo = rc.Ecodigo
									and lt.LTid = (	select max(lt2.LTid)
														from LineaTiempo lt2
														where lt.DEid = lt2.DEid
														  and lt2.LTdesde < = rc.RChasta
														  and lt2.LThasta > = rc.RCdesde )
									and lt.Tcodigo = $ATcodigo,varchar$
									and lt.RHPid = p.RHPid
									and lt.Ecodigo = p.Ecodigo
									and cf.CFid=coalesce(p.CFidconta, p.CFid)
						   			order by DEidentificacion"
						   desplegar="DEidentificacion1,Nombre1"
						   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
						   filtrar_por_delimiters="|"
						   etiquetas="#LB_Identificacion#,#LB_Nombre#"
						   formatos="S,S"
						   align="left,left"
						   asignar="DEid1,DEidentificacion1,Nombre1"
						   asignarformatos="S,S,S"
						   showemptylistmsg="true"
						   alt="ID,#LB_Identificacion#,#LB_Nombre#">

					</td>
				</tr>
				<tr  id="id_emplA2">
					<td align="right"><strong>#LB_EmpleadoHasta#:</strong>&nbsp;</td>
					<td>
						<cf_conlis
						   campos="DEid2,DEidentificacion2,Nombre2"
						   desplegables="N,S,S"
						   modificables="N,S,N"
						   size="0,20,40"
						   title="#LB_ListaDeEmpleados#"
						   tabla="RCalculoNomina rc,SalarioEmpleado se, DatosEmpleado de, LineaTiempo lt, RHPlazas p, CFuncional cf"
						   columnas="de.DEid as DEid2, de.DEidentificacion as DEidentificacion2, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as Nombre2"
						   filtro="rc.Ecodigo = #Session.Ecodigo#
						   			and rc.RCNid = $ARCNid,numeric$
						   			and rc.RCNid = se.RCNid
									and de.DEid = se.DEid
									and se.DEid = lt.DEid
									and lt.Ecodigo = rc.Ecodigo
									and lt.LTid = (	select max(lt2.LTid)
														from LineaTiempo lt2
														where lt.DEid = lt2.DEid
														  and lt2.LTdesde < = rc.RChasta
														  and lt2.LThasta > = rc.RCdesde )
									and lt.Tcodigo = $ATcodigo,varchar$
									and lt.RHPid = p.RHPid
									and lt.Ecodigo = p.Ecodigo
									and cf.CFid=coalesce(p.CFidconta, p.CFid)
						   			order by DEidentificacion"
						   desplegar="DEidentificacion2,Nombre2"
						   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
						   filtrar_por_delimiters="|"
						   etiquetas="#LB_Identificacion#,#LB_Nombre#"
						   formatos="S,S"
						   align="left,left"
						   asignar="DEid2,DEidentificacion2,Nombre2"
						   asignarformatos="S,S,S"
						   showemptylistmsg="true"
						   alt="ID,#LB_Identificacion#,#LB_Nombre#"
						   index="2">

					</td>
				</tr>
				<tr id="id_emplH1" style="display:none">
					<td align="right"><strong>#LB_EmpleadoDesde#:</strong>&nbsp;</td>
					<td>
						<cf_conlis
						   campos="DEid3,DEidentificacion3,Nombre3"
						   desplegables="N,S,S"
						   modificables="N,S,N"
						   size="0,20,40"
						   title="#LB_ListaDeEmpleados#"
						   tabla="HRCalculoNomina rc,HSalarioEmpleado se, DatosEmpleado de, LineaTiempo lt, RHPlazas p, CFuncional cf"
						   columnas="de.DEid as DEid3, de.DEidentificacion as DEidentificacion3, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as Nombre3"
						   filtro="rc.Ecodigo = #Session.Ecodigo#
						   			and rc.RCNid = $HRCNid,numeric$
						   			and rc.RCNid = se.RCNid
									and de.DEid = se.DEid
									and se.DEid = lt.DEid
									and lt.Ecodigo = rc.Ecodigo
									and lt.LTid = (	select max(lt2.LTid)
														from LineaTiempo lt2
														where lt.DEid = lt2.DEid
														  and lt2.LTdesde < = rc.RChasta
														  and lt2.LThasta > = rc.RCdesde )
									and lt.Tcodigo = $HTcodigo,varchar$
									and lt.RHPid = p.RHPid
									and lt.Ecodigo = p.Ecodigo
									and cf.CFid=coalesce(p.CFidconta, p.CFid)
						   			order by DEidentificacion"
						   desplegar="DEidentificacion3,Nombre3"
						   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
						   filtrar_por_delimiters="|"
						   etiquetas="#LB_Identificacion#,#LB_Nombre#"
						   formatos="S,S"
						   align="left,left"
						   asignar="DEid3,DEidentificacion3,Nombre3"
						   asignarformatos="S,S,S"
						   showemptylistmsg="true"
						   alt="ID,#LB_Identificacion#,#LB_Nombre#">

					</td>
				</tr>
				<tr  id="id_emplH2" style="display:none">
					<td align="right"><strong>#LB_EmpleadoHasta#:</strong>&nbsp;</td>
					<td>
						<cf_conlis
						   campos="DEid4,DEidentificacion4,Nombre4"
						   desplegables="N,S,S"
						   modificables="N,S,N"
						   size="0,20,40"
						   title="#LB_ListaDeEmpleados#"
						   tabla="HRCalculoNomina rc,HSalarioEmpleado se, DatosEmpleado de, LineaTiempo lt, RHPlazas p, CFuncional cf"
						   columnas="de.DEid as DEid4, de.DEidentificacion as DEidentificacion4, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)} as Nombre4"
						    filtro="rc.Ecodigo = #Session.Ecodigo#
						   			and rc.RCNid = $HRCNid,numeric$
						   			and rc.RCNid = se.RCNid
									and de.DEid = se.DEid
									and se.DEid = lt.DEid
									and lt.Ecodigo = rc.Ecodigo
									and lt.LTid = (	select max(lt2.LTid)
														from LineaTiempo lt2
														where lt.DEid = lt2.DEid
														  and lt2.LTdesde < = rc.RChasta
														  and lt2.LThasta > = rc.RCdesde )
									and lt.Tcodigo = $HTcodigo,varchar$
									and lt.RHPid = p.RHPid
									and lt.Ecodigo = p.Ecodigo
									and cf.CFid=coalesce(p.CFidconta, p.CFid)
						   			order by DEidentificacion"
						   desplegar="DEidentificacion4,Nombre4"
						   filtrar_por="de.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )},  ' ' )}, de.DEnombre)}"
						   filtrar_por_delimiters="|"
						   etiquetas="#LB_Identificacion#,#LB_Nombre#"
						   formatos="S,S"
						   align="left,left"
						   asignar="DEid4,DEidentificacion4,Nombre4"
						   asignarformatos="S,S,S"
						   showemptylistmsg="true"
						   alt="ID,#LB_Identificacion#,#LB_Nombre#">

					</td>
				</tr>
				<cfif rsEmpresa.RecordCount NEQ 0>
				<tr>
					<td align="right" valign="middle"></td>
					<td>
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="1%"><input type="checkbox" name="corteBoleta" id="corteBoleta"/></td>
								<td width="100%" nowrap="nowrap"><label for="corteBoleta"><cf_translate key="LB_CortePorBoleta">Corte por boleta</cf_translate></label></td>
							</tr>
						</table>
					</td>
				</tr>
				</cfif>
				<tr>
					<td colspan="2" align="center"><input type="submit" name="btnConsultar" value="#vConsultar#" class="btnNormal" /></td>
				</tr>
			</table>

			<input type="hidden" name="CFidconta" value=""  />
			<input type="hidden" name="RCNid" value=""  />
			<input type="hidden" name="tipo" value=""  />
		</form>
		</cfoutput>
		<cf_web_portlet_end>

		<cf_qforms>

		<cfoutput>
		<script type="text/javascript" language="javascript1.2">
			objForm.HRCNid.required = false;
			objForm.ARCNid.required = true;
			objForm.HRCNid.description = '#vRelacion#';
			objForm.ARCNid.description = '#vRelacion#';
			objForm.CFid.required = true;
			objForm.CFid.description = '#vCentro#';
			objForm.ATcodigo.description = '#vRelacion#';
			objForm.HTcodigo.description = '#vRelacion#';


			function validar(){
				document.form1.CFidconta.value = document.form1.CFid.value;

				if (document.form1.nominas.value == 'H'){
					document.form1.RCNid.value = document.form1.HRCNid.value;
					document.form1.tipo.value = 'H';
				}
				else{
					document.form1.RCNid.value = document.form1.ARCNid.value;
					document.form1.tipo.value = 'A';
				}

				return true;
			}

			function conlisRelacion(valor){
				document.form1.htipo.value = '';
				document.form1.HRCNid.value = '';
				document.form1.HTcodigo.value = '';
				document.form1.HTdescripcion.value = '';
				document.form1.HRCDescripcion.value = '';
				document.form1.atipo.value = '';
				document.form1.ARCNid.value = '';
				document.form1.ATcodigo.value = '';
				document.form1.ATdescripcion.value = '';
				document.form1.ARCDescripcion.value = '';
				document.form1.DEid1.value = '';
				document.form1.DEidentificacion1.value = '';
				document.form1.Nombre1.value = '';
				document.form1.DEid2.value = '';
				document.form1.DEidentificacion2.value = '';
				document.form1.Nombre2.value = '';
				document.form1.DEid3.value = '';
				document.form1.DEidentificacion3.value = '';
				document.form1.Nombre3.value = '';
				document.form1.DEid4.value = '';
				document.form1.DEidentificacion4.value = '';
				document.form1.Nombre4.value = '';

				if (valor == 'H'){
					document.getElementById('id_cerradas').style.display = '';
					document.getElementById('id_emplH1').style.display = '';
					document.getElementById('id_emplH2').style.display = '';
					document.getElementById('id_abiertas').style.display = 'none';
					document.getElementById('id_emplA1').style.display = 'none';
					document.getElementById('id_emplA2').style.display = 'none';
					objForm.HRCNid.required = true;
					objForm.ARCNid.required = false;
					document.form1.RCNid.value = '';
				}
				else{
					document.getElementById('id_cerradas').style.display = 'none';
					document.getElementById('id_emplH1').style.display = 'none';
					document.getElementById('id_emplH2').style.display = 'none';
					document.getElementById('id_abiertas').style.display = '';
					document.getElementById('id_emplA1').style.display = '';
					document.getElementById('id_emplA2').style.display = '';
					objForm.ARCNid.required = true;
					objForm.HRCNid.required = false;
					document.form1.RCNid.value = '';
				}
			}

		</script>
		</cfoutput>
	<cf_templatefooter>