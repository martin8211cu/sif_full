<cfset session.sitio.template = "/plantillas/Fondos/Plantilla.cfm">


<cf_templateheader title="Pantalla de Ajustes a Relaciones">
<br>
<cfif isdefined("CJX19REL") and len(trim(CJX19REL)) gt 0 >
			
	<cfif isdefined("cmb_tdoc") and cmb_tdoc eq 2>

		<!--- El usuario ya digit una relacion por lo que se le muestran los documentos de la misma --->
		<cfquery name="Pagos" datasource="#session.Fondos.dsn#">
			select CJX23CON,case when CJX23TIP= 'C' then 'Cheque' when CJX23TIP= 'E' then 'Efectivo' when CJX23TIP= 'T' then 'Tarjeta' when CJX23TIP= 'V' then 'Vale' end CJX20TIP,
			CJX23MON * case when CJX23TTR = 'D' then -1 else 1 end CJX23MON,CJX23TIP,
			case 
			when CJX23TIP= 'C' then 'No.[' +CJX23CHK +']' 
			when CJX23TIP= 'E' then '-' 
			when CJX23TIP= 'T' then 'No.[' +TR01NUT +'] autorizacin [' +CJX23AUT +']' 
			when CJX23TIP= 'V' then 'No.['+convert(varchar,CJX5IDE,1)+']' 
			end DOCUMENTO,CJX23AUT
			from CJX023 , CJX019
			where CJX023.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#CJX19REL#" >
			and CJX19EST = 'P'
			and CJ01ID = '#session.Fondos.Caja#'
			and CJX023.CJX19REL = CJX019.CJX19REL
			<cfif isdefined("DOCUMENTO") and trim(DOCUMENTO) neq "">
				and CJX23AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DOCUMENTO#" >
			</cfif>
			<!---
			<cfif isdefined("CP9COD") and trim(CP9COD) neq "">
			    and CP9COD = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CP9COD#" > 
			</cfif>			
			 --->
			<cfif isdefined("CJX20FEF") and trim(CJX20FEF) neq "">
			    and CJX23FEC = <cfqueryparam cfsqltype="cf_sql_datetime"  value="#dateformat(form.CJX20FEF,"yyyymmdd")#" >
			</cfif> 						
			<cfif isdefined("CJX20MNT") and trim(CJX20MNT) neq "" and trim(CJX20MNT) neq "0.00">
			    <cfset Var_CJX20MNT = #val(replace(CJX20MNT,",",""))#>
			    and CJX23MON = <cfqueryparam cfsqltype="cf_sql_money" value="#Var_CJX20MNT#" >
			</cfif> 			
			<!---
			<cfif isdefined("EMPCOD") and trim(EMPCOD) neq "">
				and EMPCOD = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.EMPCOD#" >
			</cfif>						
			--->
		</cfquery>
	
	<cfelse>
			
		<cfquery name="Facturas" datasource="#session.Fondos.dsn#">
			select CJX20NUM
			,case when CJX20TIP= 'A' then 'Ajuste' when CJX20TIP= 'F' then 'Factura' when CJX20TIP= 'V' then 'Viaticos y Otros' end CJX20TIP
			,convert(varchar(10),CJX20FEF,103)CJX20FEF
			,CJX20MNT
			,CJX20NUF 
			from CJX020, CJX019
			where CJX020.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#Val(CJX19REL)#" >
			and CJ01ID = '#session.Fondos.Caja#'
			and CJX19EST = 'P'
			and CJX020.CJX19REL = CJX019.CJX19REL
			
			<cfif isdefined("DOCUMENTO") and trim(DOCUMENTO) neq "">
				and CJX20NUF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DOCUMENTO#" >
			</cfif>
			<cfif isdefined("CP9COD") and trim(CP9COD) neq "">
			    and CP9COD = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CP9COD#" > 
			</cfif>			
			<cfif isdefined("CJX20FEF") and trim(CJX20FEF) neq "">
			    and CJX20FEF = <cfqueryparam cfsqltype="cf_sql_datetime"  value="#dateformat(form.CJX20FEF,"yyyymmdd")#" >
			</cfif> 			
			<cfif isdefined("CJX20MNT") and trim(CJX20MNT) neq "" and trim(CJX20MNT) neq "0.00">
			    <cfset Var_CJX20MNT = #val(replace(CJX20MNT,",",""))#>
				and CJX20MNT = <cfqueryparam cfsqltype="cf_sql_money"  value="#Var_CJX20MNT#" >
			</cfif>						
			<cfif isdefined("EMPCOD") and trim(EMPCOD) neq "">
				and EMPCOD = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.EMPCOD#" >
			</cfif>			
		
			
		</cfquery>
	
			
	</cfif>
	
</cfif>

<cfif isdefined("CJX19REL") and CJX19REL neq "">
				
		<cfquery datasource="#session.Fondos.dsn#" name="rsRelacion">
			select CJX19REL, CJX19FED, CJX19FEP, 'Relacion Masiva' as DCJX19REL
			from CJX019
			where CJX19EST = 'P'
			  and CJ01ID = '#session.Fondos.Caja#'
              and CJX19REL = #CJX19REL#
		</cfquery>		
		
</cfif>

<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<script>
function CambiaTexto(numdesc, contenedor)
{
	var textos=new Array();
	textos[0]="Filtrar por nmero de documento";
    textos[1]="Filtrar por nmero de autorizacion";	
	numdesc=numdesc-1;
    document.getElementById(contenedor).innerHTML=textos[numdesc];
}
</script>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {color: #FFFF00}
-->
</style>



	<!--- Se solicita el # de relacion --->
	<form action="cjc_AjusteRelacion.cfm" method="post" name="frm_ajuste">
	<table>
	<tr>
		<td>Num. Relacion a Ajustar:</td>
		<td colspan="3">
				<cfif not isdefined("rsRelacion")>
				<cf_cjcConlis 	
					size		="30" 
					tabindex    ="1" 
					form		="frm_ajuste"
					name 		="CJX19REL" 
					desc 		="DCJX19REL" 
					id			="CJX19REL" 
					cjcConlisT 	="cjc_traeRelaciones"
					frame		="frmajuste"
				>
				<cfelse>
				<cf_cjcConlis 	
					size		="30" 
					tabindex    ="1"
					form		="frm_ajuste"
					name 		="CJX19REL"
					desc 		="DCJX19REL"
					id			="CJX19REL" 
					cjcConlisT 	="cjc_traeRelaciones"
					query       ="#rsRelacion#"
					frame		="frmajuste"
				>
				</cfif>
		</td>
	</tr>
	<!--- 
	<tr>
		<td>Num. Relacion a Ajustar:</td>
		<td colspan="3">
			<INPUT 	TYPE="textbox" 
					NAME="CJX19REL1" 
					SIZE="15" 
					VALUE="<cfif isdefined("Form.CJX19REL")><cfoutput>#Form.CJX19REL#</cfoutput></cfif>" 
					MAXLENGTH="15"  
					ONBLUR="javascript: fm(this,0);" 
					ONFOCUS="javascript: this.value=qf(this); this.select(); " 
					ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){}} " >
		</td>		
	</tr>
	 --->
	<tr>
		<td>Tipo de Documento:</td>
		<td colspan="3">
			<select name="cmb_tdoc" style="width:120px" onChange="javascript:CambiaTexto(this.value, 'textocorrespondiente')">
			<cfif not isdefined("cmb_tdoc")>
				<option value="1" selected>Gasto</option>
				<option value="2">Anticipo</option>		
				<cfset numdesc=1>
			<cfelse>			
				<cfif cmb_tdoc eq 1>
					<option value="1" selected>Gasto</option>
					<option value="2">Anticipo</option>
					<cfset numdesc=1>
				<cfelse>
					<option value="1">Gasto</option>
					<option value="2" selected>Anticipo</option>			
					<cfset numdesc=2>
				</cfif>
			</cfif>
			</select>
		</td>		
	</tr>	
	<tr>
	    <td>
		<span id="textocorrespondiente" align="left">
		</span>		
		<cfoutput>
			<script>CambiaTexto(#numdesc#, 'textocorrespondiente')</script>	
		</cfoutput>
		</td>
		<td>
			<INPUT 	TYPE="textbox" 
					NAME="DOCUMENTO" 
					SIZE="15" 					
					MAXLENGTH="15"  
					ONBLUR="javascript: fm(this,0);" 
					ONFOCUS="javascript: this.value=qf(this); this.select(); " 
					ONKEYUP="javascript: if(snumber(this,event,0)){ if(Key(event)=='13'){}} " >				   		
		</td>
	</tr>	
	<tr>		
		<td>Filtrar por Cdula de Empleado:</td>
		<td>								
				<cf_cjcConlis 	
					size		="30" 
					tabindex    ="1" 
					name 		="EMPCED" 
					desc 		="NOMBRE" 
					id			="EMPCOD" 
					name2		="DEPCOD"
					desc2		="DEPDES"
					cjcConlisT 	="cjc_traeEmp"
					form   		="frm_ajuste"
				>
									
		</td>
	</tr>
	<tr>
		<td>Filtrar por Cdula de Autorizador:</td>
		<td>					
					<cf_cjcConlis 	
							size		="30"  
							tabindex    ="1"
							name 		="CP9COD" 
							desc 		="CP9DES" 
							cjcConlisT 	="cjc_traeAut"
							form		="frm_ajuste"
					>
		</td>
	</tr>	
	<tr>		
		<td>Filtrar por Fecha de Documento:</td>
		<td>
		    <cfif isdefined("CJX20FEF") and trim(CJX20FEF) neq "">
				<cfset CJX20FEF = #CJX20FEF#>
			<cfelse>
				<cfset CJX20FEF = "" >
			</cfif>		
			<cfoutput>
			<cf_CJCcalendario  tabindex    ="1" name="CJX20FEF" form="frm_ajuste">  <!--- value="#CJX20FEF#"> --->
			</cfoutput>
		</td>
	</tr>	
	
	
	<tr>
		<td>Filtrar por Monto:</td>
		<td colspan="3">
				<INPUT 	TYPE="textbox" 
					NAME="CJX20MNT" 
					VALUE="0.00" 
					SIZE="20" 
					MAXLENGTH="15" 
					ONBLUR="javascript: fm(this,2);"
					ONFOCUS="javascript: this.value=qf(this); this.select(); " 
					ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
					tabindex="1"
				>				
		</td>
	</tr>		
	<tr>
		<td colspan="2"><input type="submit" name="btnVerGastos" id="btnVerGastos" value="Ver Documentos"></td>
	</tr>
	</table>
	<input type="hidden" name="EMPCOD">
	<input type="hidden" name="DEPCOD">
	<input type="hidden" name="DEPDES">
	</form>
	<br>
	<!---
	<a href="cjc_MantenimientoBancos.cfm">test</a>
	--->
<!--- Como ya se digito la relacion se muestran los documentos --->
<cfif isdefined("CJX19REL") and len(trim(CJX19REL)) gt 0>

	
	<table cellpadding="0" cellspacing="0" width="80%" bgcolor="steelblue" >
	<tr>
  	    <cfif isdefined("cmb_tdoc") and cmb_tdoc eq 1>
			<cfif Facturas.recordcount gt 0>
				<td>
					<table cellpadding="0" cellspacing="0" width="100%" bgcolor="steelblue" >
					<tr>
						<td colspan="5"  align="center">
							<strong><span class="style1">Facturas</span></strong>
						</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td> <span class="style1">Lnea</span></td>
						<td> <span class="style1">Tipo</span></td>
						<td> <span class="style1">Fecha</span></td>
						<td> <span class="style1">Documento</span></td>
						<td align="center"> <span class="style1">Monto</span></td>
					</tr>
					<cfoutput query="Facturas">
						<tr>               
							<td><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&TD=#cmb_tdoc#"><span class="style2">#Facturas.CJX20NUM#</span></a></td>
							<td><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&TD=#cmb_tdoc#"><span class="style2">#Facturas.CJX20TIP#</span></a></td>
							<td><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&TD=#cmb_tdoc#"><span class="style2">#Facturas.CJX20FEF#</span></a></td>
							<td><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&TD=#cmb_tdoc#"><span class="style2">#Facturas.CJX20NUF#</span></a></td>
							<td align="right"><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX20NUM=#CJX20NUM#&TD=#cmb_tdoc#"><span class="style2">#LsCurrencyFormat(Evaluate('#Trim(Facturas.CJX20MNT)#'),"none")#</span></a></td>
						</tr>
					</cfoutput>			
					</table>
				</td>
			<cfelse>
	
				<script>
				alert("No hay datos para mostrar")
				</script>
				
			</cfif>
		</cfif>
		<cfif isdefined("cmb_tdoc") and cmb_tdoc eq 2>
			<cfif Pagos.recordcount gt 0>
				<td>			
					<table cellpadding="0" cellspacing="0" width="100%" bgcolor="steelblue">
					<tr>
					<td colspan="5"  align="center"><strong><span class="style1">Pagos</span></strong></td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>		
					<tr>
						<td><span class="style1">Lnea</span></td>
						<td><span class="style1">Tipo</span></td>
						<td><span class="style1">Documento</span></td>
						<td><span class="style1">Monto</span></td>
						<td><span class="style1">Estado</span></td>
					</tr>		
					<cfoutput query="Pagos">
						
						<!--- Verifica si el voucher esta conciliado --->
						<cfquery datasource="#session.Fondos.dsn#" name="verconcic">
						Select CJX23TIP
						from CJX023 A,CJX011 B
						where A.CJX19REL = B.CJX11KNM
						  and A.CJX23AUT = B.CJX11AUT
						  and A.CJX23MON = B.CJX11IMP
						  and A.TR01NUT = B.TR01NUT
						  and A.TS1COD = B.TS1COD
						  and B.PERCOD is not null
						  and B.MESCOD is not null
						  and (B.CJX00NGC is not null or B.CJX11CNS is not null)
						  and B.CJX11ORI = 'M'
						  and A.CJX23CON = #CJX23CON#
						  and A.CJX19REL = #CJX19REL#
						</cfquery>
						
						<cfif verconcic.recordcount gt 0>
							<cfloop query="verconcic"><cfset estadovou = #CJX23TIP#></cfloop>
						<cfelse>
							<cfset estadovou = ''>
						</cfif>
						
						<tr>                                       
							<td><cfif verconcic.recordcount eq 1><span class="style2">#Pagos.CJX23CON#</span><cfelse><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX23CON=#CJX23CON#&TD=#cmb_tdoc#&CJX23TIP=#CJX23TIP#"><span class="style2">#Pagos.CJX23CON#</span></a></cfif></td>
							<td><cfif verconcic.recordcount eq 1><span class="style2">#Pagos.CJX20TIP#</span><cfelse><a href="cjc_fromAjustes.cfm?CJX19REL=#CJX19REL#&CJX23CON=#CJX23CON#&TD=#cmb_tdoc#&CJX23TIP=#CJX23TIP#"><span class="style2">#Pagos.CJX20TIP#</span></a></cfif></td>
							<td><cfif verconcic.recordcount eq 1><span class="style2">#Pagos.DOCUMENTO#</span><cfelse><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX23CON=#CJX23CON#&TD=#cmb_tdoc#&CJX23TIP=#CJX23TIP#"><span class="style2">#Pagos.DOCUMENTO#</span></a></cfif></td>
							<td align="right"><cfif verconcic.recordcount eq 1 or trim(estadovou) eq 'E' or trim(estadovou) eq 'V'><span class="style2">#LsCurrencyFormat(Evaluate('#Trim(Pagos.CJX23MON)#'),"none")#</span><cfelse><a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX23CON=#CJX23CON#&TD=#cmb_tdoc#&CJX23TIP=#CJX23TIP#"><span class="style2">#LsCurrencyFormat(Evaluate('#Trim(Pagos.CJX23MON)#'),"none")#</span></a></cfif></td>
							<td>&nbsp;&nbsp;
								<cfif verconcic.recordcount eq 1 or trim(estadovou) eq 'E' or trim(estadovou) eq 'V'>
									<cfif verconcic.recordcount eq 1>
										<span class="style2">Conciliado</span>
									<cfelse>
										<cfif trim(estadovou) eq 'E'>
											Efectivo
										<cfelse>
											<cfif trim(estadovou) eq 'V'>
												Exportado
											</cfif>
										</cfif>
									</cfif>
								<cfelse>
									<a href="cjc_formAjustes.cfm?CJX19REL=#CJX19REL#&CJX23CON=#CJX23CON#&TD=#cmb_tdoc#&CJX23TIP=#CJX23TIP#"><span class="style2">No Conciliado</span></a>
								</cfif>
							</td>
						</tr>
					</cfoutput>					
					</table>						
				</td>
			<cfelse>	
				<script>
				alert("No hay datos para mostrar")
				</script>	
			</cfif>
		</cfif>
	</tr>
	</table>
	
</cfif>

<cf_templatefooter>
