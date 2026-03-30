

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoReg"
	Default="Tipo Registro"
	returnvariable="LB_TipoReg"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DesAct"
	Default="Descripcion"
	returnvariable="LB_DesAct"/>	
	
<cfobject component="rh.Componentes.RH_ActCFuncional" name="CF">
<cfset vErrores = CF.Actualiza(form.RCNid,form.CFid,form.CFpk)>
<cfquery dbtype="query" name="vErr" result="Err">
	select * from vErrores
</cfquery>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr>
		<td valign="top">
			<table width="100%">
				<tr>
					<td valign="top" width="80%">
					<div align="left" style="background-color:#E5E5E5; font-size:13px;">
						<cfinvoke
							component="rh.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet"
								query="#vErr#"
								usaAJAX ="true"
								conexion = "#session.dsn#"
								desplegar="descripcion,tiporeg"
								etiquetas="#LB_DesAct#,#LB_TipoReg#"
								checkall = "N"
								formatos="V,V"
								align="left,Center"
								ajustar="N"
								checkboxes="N"
								irA="CFuncional-Act.cfm"
								keys="CFformato"
								showEmptyListMsg="true"
								showlink="false"
								PageIndex = "3"
								maxrows="25"
								formName="frmTab3"
								queryResult="#Err#"/>
					</div>
					</td>
				</tr>
			</table>
		</td>	
	</tr>
</table>	
