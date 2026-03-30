<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Codigo"
	returnvariable="LB_Codigo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripcion"
	returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agrega"
	Default="Agregar"
	returnvariable="BTN_Agrega"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Genera"
	Default="Generar Asientos"
	returnvariable="BTN_Genera"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncionalProp"
	Default="Centro Funcional Propuesto"
	returnvariable="LB_CentroFuncionalProp"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncionalAct"
	Default="Centro Funcional Actual"
	returnvariable="LB_CentroFuncionalAct"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaCentroFuncionalProp"
	Default="Lista de Centros Funcionales Propuestos"
	returnvariable="LB_ListaCentroFuncionalProp"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoCentrosPropuestos"
	Default="No Existen Centros Funcionales Propuestos"
	returnvariable="LB_NoCentrosPropuestos"/>		
		
		
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cfinclude template="/rh/Utiles/params.cfm">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeCentrosFuncionales"
	Default="Lista de Centros Funcionales Inactivos"
	returnvariable="LB_ListaDeCentrosFuncionales"/>

<cfinclude template="/rh/portlets/pNavegacion.cfm">

<cfoutput>

<cfset imgok = "">
<cfif isdefined('form.Error') and  #form.Error# EQ 1>
	<cfset imgrecalcular = "<img border=''0'' src=''/cfmx/rh/imagenes/Cferror.gif''>">							
<cfelse>	
	<cfset imgrecalcular = "">
</cfif>

<!--- CarolRS, se modifica la tabla para incluir la nueva tabla de RCuentasTipoExactus en el filtro --->
<cfquery datasource="#session.dsn#" name="rsCFInac">
	select distinct 1 as tab, b.CFid, b.CFid as CFpk, a.RCNid, b.CFcodigo as CFcod, 
	b.CFdescripcion as CFdescrip, b.CFcuentac, '#imgrecalcular#' as Err
	from CFuncional b
		inner join RCuentasTipo a
			on b.CFid = a.CFid
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	where b.Ecodigo = #session.Ecodigo#
		and b.CFestado = 0
		and  ( select count(1)
							from RCuentasTipoExactus x
							where x.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#"> 
							and a.CFid=x.CFidAnt)= 0
</cfquery>

<!--- CarolRS, trae los centros funcionales propuestos --->
<cfquery datasource="#session.dsn#" name="rsCentrosPropuestos">
	select distinct b.CFid, c.CFid as CFidAnt,b.CFcodigo, c.CFcodigo as CFcodigoAnt, b.CFdescripcion,c.CFdescripcion as CFdescripcionAnt, b.CFestado,c.CFestado as CFestadoAnt 
	from  RCuentasTipoExactus a
		inner join CFuncional b
		on b.CFid = a.CFid
		and b.Ecodigo = #session.Ecodigo#
		
		inner join CFuncional c
		on c.CFid = a.CFidAnt
		and c.Ecodigo = #session.Ecodigo#
	where 
		a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		and a.Ecodigo = #session.Ecodigo#
</cfquery>

<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<cfif rsCFInac.recordCount gt 0>
	<tr>
		<td valign="top">
			<cf_web_portlet_start border="true" titulo="#LB_CentroFuncional#" >
			<table width="100%">
				<tr>
					<td valign="top" width="50%">
						
						<cfquery datasource="#session.dsn#" name="rsCFInac" result="qrCFInac">
							select distinct 1 as tab, b.CFid, b.CFid as CFpk, a.RCNid, b.CFcodigo as CFcod, 
								b.CFdescripcion as CFdescrip, b.CFcuentac, '#imgrecalcular#' as Err
								from CFuncional b
									inner join RCuentasTipo a
										on b.CFid = a.CFid
										and a.RCNid = #form.RCNid#
								where b.Ecodigo = #session.Ecodigo#
									and b.CFestado = 0
									and (Select count(1) 
										 from RCuentasTipoExactus x
										 Where a.CFid = x.CFidAnt
										 and x.RCNid = #form.RCNid#
										 and x.Ecodigo = #session.Ecodigo#) = 0

						</cfquery>
						
						<cfinvoke
							component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"
								query="#rsCFInac#"
								usaAJAX ="true"
								conexion = "#session.dsn#"
								desplegar="CFcod,CFdescrip,Err"
								etiquetas="#LB_Codigo#,#LB_Descripcion#,&nbsp;"
								formatos="V,V,S"
								align="left,left,Center"
								ajustar="N"
								checkboxes="N"
								irA="CFuncional-Act.cfm"
								keys="RCNid,CFpk"
								showEmptyListMsg="true"
								showlink="true"
								PageIndex = "1"
								maxrows="25"
								formName="frmLista"
								queryResult="#qrCFInac#"/>
					</td>
					<td valign="top" width="50%">
							<form name="frmTab1" method="post" action="Act_CFuncional_sql.cfm" onsubmit="return fnValidar();">
							<table border="0" cellspacing="1" cellpadding="0">
								<cfoutput>
									<tr> 
										<td width="10%" align="right" nowrap><strong>#LB_CentroFuncionalAct#:&nbsp;</strong></td>
										<td  valign="middle" nowrap>
										<input name="CFcodigo1" type="text" id="CFcodigo1" size ="10" readonly="true"
											value="<cfif isdefined("form.CFcod")><cfoutput>#trim(form.CFcod)#</cfoutput></cfif>">
										<input name="CFdescripcion1" type="text" id="CFdescripcion1"  size="39"readonly="true"
											value="<cfif isdefined("form.CFdescrip")><cfoutput>#trim(form.CFdescrip)#</cfoutput></cfif>">
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap><strong>#LB_CentroFuncionalProp#:&nbsp;</strong></td>
										<cfset lvarExcluir = "">
										<cfif isdefined('form.RCNid') and len(trim(form.RCNid)) and isdefined('form.CFpk') and len(trim(form.CFpk))>
											<cfset lvarExcluir = form.CFpk>
										</cfif>
										<td><cf_rhcfuncional width = "900" form="frmTab1" tabindex="1" excluir="#lvarExcluir#"></td>
									</tr>
									<tr>
										<td align="center" colspan="3">
											<input type="submit" name="Agregar" value="#BTN_Agrega#">
											<cfif isdefined('form.RCNid') and len(trim(form.RCNid)) and isdefined('form.CFpk') and len(trim(form.CFpk))>
												<input type="hidden" name="RCNid" value="#form.RCNid#">
												<input type="hidden" name="CFpk" value="#form.CFpk#">
												<input name="CFdescrip" type="hidden" value="#form.CFdescrip#">
												<input name="CFcod"  	type="hidden" value="#form.CFcod#">
											</cfif>
											<cfif isdefined('modo')>
												<input type="hidden" name="modo" value="#modo#">
											</cfif>
										</td>
									</tr>
								</cfoutput>
								</table>
								</form>
					</td>
				</tr>
			</table>
			<cf_web_portlet_end>
		</td>	
	</tr>
	</cfif>
	
	<tr>
		<td valign="top" colspan="2">
			
			
			<cf_web_portlet_start border="true" titulo="#LB_ListaCentroFuncionalProp#" >
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<!---<tr><td align="center"><cfdump var="#rsCentrosPropuestos#"></td></tr>--->
				<cfif rsCentrosPropuestos.recordCount EQ 0 >
					<tr><td align="center">---#LB_NoCentrosPropuestos#---</td></tr>
				<cfelse>
					<tr><td valign="top" align="center">
							<table width="70%" cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td align="center"><strong>#LB_CentroFuncional#</strong></td>
									<td align="center">&nbsp;</td>
									<td align="center"><strong>#LB_CentroFuncionalProp#</strong></td>
									<td align="center">&nbsp;</td>
									<td align="center">&nbsp;</td>
								</tr>
								<cfloop query="rsCentrosPropuestos">
								<tr>
									<td align="center">#rsCentrosPropuestos.CFcodigoAnt# - #rsCentrosPropuestos.CFdescripcionAnt#
										<cfif rsCentrosPropuestos.CFestadoAnt is 0>
											(Inactivo)
										<cfelse>
											(Activo)
										</cfif>
									</td>
									<td>&nbsp;
											
									</td>
									<td align="center">#rsCentrosPropuestos.CFcodigo# - #rsCentrosPropuestos.CFdescripcion#
										<cfif rsCentrosPropuestos.CFestado is 0>
											(Inactivo)
										<cfelse>
											(Activo)
										</cfif>
									</td>
									<td>&nbsp;
										
									</td>
									<td align="center"><img src="../../imagenes/Borrar01_12x12.gif" onclick="javascript: BorrarCentroPropuesto(#rsCentrosPropuestos.CFidAnt#,#rsCentrosPropuestos.CFid#)"/></td>
								</tr>
								</cfloop>
								<cfif rsCFInac.recordCount EQ 0>
									<tr><td colspan="5" align="center">
										<form name="frmGenerar" method="post" action="Act_CFuncional_sql.cfm" onsubmit="return fnValidaGeneracion();">
											<input type="submit" name="Generar" value="#BTN_Genera#">
											<cfif isdefined('form.RCNid') and len(trim(form.RCNid))>
												<input type="hidden" name="RCNid" value="#form.RCNid#">
											</cfif>
										</form>
									</td></tr>
								</cfif>
								
							</table>
						</td></tr>
					</cfif>
			</table>
			<form name="frmProp" method="post" action="Act_CFuncional_sql.cfm">
				<input type="hidden" id="RCNid" 			name="RCNid" 	value="#form.RCNid#"/>
				<input type="hidden" id="CFid" 				name="CFid" 	value=""/>
				<input type="hidden" id="CFidAnt" 			name="CFidAnt" 	value=""/>
				<input type="hidden" id="BorrarPropuesto" 	name="BorrarPropuesto" 	value="1"/>
				<input name="CFdescrip" type="hidden" value="">
				<input name="CFcod"  	type="hidden" value="">
			</form>
			
			<cf_web_portlet_end>
		</td>
	</tr>
</table>	

<cfif rsCFInac.recordCount gt 0>
	<cf_qforms form="frmTab1">
	<script type="text/javascript" language="javascript1.2">
	
		objForm.CFid.required = true;
		objForm.CFid.description = '#LB_CentroFuncionalProp#';
		
		function fnValidar(){
			if(document.frmTab1.CFpk.value == document.frmTab1.CFid.value){
				alert("El Centro Funcional no puede ser el mismo. Corriga el dato para continuar.");
				return false;
			}
			if(confirm("Esta seguro que desea agregar la propuesta?"))
				return true;
			return false;
		}
	</script>
</cfif>

<script type="text/javascript" language="javascript1.2">
	function fnValidaGeneracion(){
		if(confirm("Esta seguro de continuar el proceso?"))
			return true;
		return false;
	}
	

	function BorrarCentroPropuesto(CFidAnt,CFid){
		if(confirm('Esta seguro que desea borrar la propuesta?')){
			document.frmProp.CFidAnt.value = CFidAnt;
			document.frmProp.CFid.value = CFid;
			document.frmProp.submit();
		}
	}
</script>

</cfoutput>

