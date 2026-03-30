<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CFAct"
	Default="CF Actual"
	returnvariable="LB_CFAct"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DesAct"
	Default="Descripcion"
	returnvariable="LB_DesAct"/>	

<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr>
	
		<td valign="top">
			<table width="100%">
				<tr>
					<td valign="top" width="80%">
						<div align="left" style="background-color:#E5E5E5; font-size:13px;">
					<cfquery datasource="#session.dsn#" name="rsCFInacEmp">
						select distinct 2 as tab, rc.RCNid, b.CFid,rc.DEid, b.CFcodigo, b.CFdescripcion,
							<cf_dbfunction name="concat" args="c.DEapellido1,'  ',c.DEapellido2, ' ',c.DEnombre" > as Nombre,
							
							(select coalesce(CFidconta,b.CFid)
								from LineaTiempo a
									inner join RHPlazas b
										on a.RHPid = b.RHPid
									inner join CFuncional c
										on coalesce(b.CFidconta,b.CFid) = c.CFid
								where a.DEid = rc.DEid <!---#form.DEid#--->
									and a.LTdesde <= getdate()
									and a.LThasta >= getdate()
									) as CFidAct,
							(select c.CFcodigo
								from LineaTiempo a
									inner join RHPlazas b
										on a.RHPid = b.RHPid
									inner join CFuncional c
										on coalesce(b.CFidconta,b.CFid) = c.CFid
								where a.DEid = rc.DEid
									and a.LTdesde <= getdate()
									and a.LThasta >= getdate()
									) as CFcodigoAct,
							(select c.CFdescripcion
								from LineaTiempo a
									inner join RHPlazas b
										on a.RHPid = b.RHPid
									inner join CFuncional c
										on coalesce(b.CFidconta,b.CFid) = c.CFid
								where a.DEid = rc.DEid
									and a.LTdesde <= getdate()
									and a.LThasta >= getdate()
									) as CFdescripcionAct
						from RCuentasTipo rc
							inner join CFuncional b
								on rc.CFid = b.CFid
								and b.CFestado = 0
							inner join DatosEmpleado c
								on rc.DEid = c.DEid
						where  rc.Ecodigo = #session.Ecodigo#
								and rc.RCNid = #form.RCNid#
								<cfif isdefined('form.CFid')>
									and rc.CFid = #form.CFpk#
								</cfif>
						order by Nombre
					</cfquery>
				
					<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"
							query="#rsCFInacEmp#"
							usaAJAX ="true"
							conexion = "#session.dsn#"
							desplegar="Nombre,CFcodigoAct,CFdescripcionAct"
							etiquetas="#LB_Nombre#,#LB_CFAct#,#LB_DesAct#"
							checkall = "N"
							formatos="V,V,V"
							align="left,left,left"
							ajustar="N"
							checkboxes="N"
							irA="CFuncional-Act.cfm"
							keys="RCNid,CFid,DEid"
							showEmptyListMsg="true"
							showlink="false"
							PageIndex = "2"
							maxrows="25"
							formName="frmTab2"/>
				</div>
					</td>
					<!---
					<td valign="top" width="50%">
						<cfinclude template="Act_CFuncional-Detalle.cfm">
					</td>
					--->
				</tr>
			</table>
		</td>	
	</tr>
</table>	
