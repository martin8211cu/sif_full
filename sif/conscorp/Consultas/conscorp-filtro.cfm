<!--- Query en el Framework para saber el total de las Corporaciones --->
<cfquery name="rsEmpCorp" datasource="asp">
	select a.CEcodigo, ce.CEnombre, a.Ecodigo as EcodigoSDC, a.Ereferencia as Ecodigo, a.Enombre, m.Mnombre, c.Ccache
	from CuentaEmpresarial ce,
		 Empresa a,
		 CECaches b,
		 Caches c,
		 Moneda m
	where ce.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ce.CEcodigo = a.CEcodigo
	  and a.Cid = b.Cid
	  and a.CEcodigo = b.CEcodigo
	  and b.Cid = c.Cid
	  and a.Mcodigo = m.Mcodigo
</cfquery>
<cfquery name="rsCorp" dbtype="query">
	Select distinct CEnombre
	from rsEmpCorp
</cfquery>
<style type="text/css">
<!--
.style2 {font-weight: bold; font-size: 14px;}
.style3 {font-weight: bold}
-->
</style>

<cfif Len(Month(Now())) EQ 1>
	<cfset mes = '0' & Month(Now())>
<cfelse>
	<cfset mes = Month(Now())>
</cfif>

<cfset fechaIni = '01/' & mes & '/' & Year(Now())>
<cfset fechaFin = DaysInMonth(Now()) & '/' & mes & '/' & Year(Now())>
	<form action="conscorp.cfm" name="formFiltroEmpresas" method="post" onSubmit="javascript: return validaFiltro(this);">
		<cfoutput>
		  <table width="100%" border="0" class="areaFiltro">
            <tr>
              <td colspan="2">
				  <table width="100%" border="0">
					<tr>
					  <td width="9%" align="center"><input <cfif isdefined('form.ckTodas')> checked</cfif> style="border: '0'" class="areaFiltro" type="checkbox" name="ckTodas" onClick="javascript: marcarTodas(this);" value="1">
					  Todas</td>
					  <td width="91%" align="center" class="style2"><cfoutput><span class="style2">Empresas de la Corporaci&oacute;n: #rsCorp.CEnombre#</span></cfoutput></td>
					</tr>
				  </table>
			  </td>
            </tr>
            <tr>
              <td width="52%" align="center">
				<table width="70%" border="0">
				  <cfset band = 0>
				  <cfset marcado = 0>					  
				  <cfloop query="rsEmpCorp">
						<cfif isdefined('form.btnFiltrar') and isdefined('form.ckEmpresa')>
							<cfif ListLen(form.ckEmpresa,',') GT 1>
								<cfif ListFind(form.ckEmpresa, rsEmpCorp.EcodigoSDC , ',') GT 0>
									<cfset marcado = 1>											
								<cfelse>
									<cfset marcado = 0>											
								</cfif>
							<cfelse>
								<cfif rsEmpCorp.EcodigoSDC EQ form.ckEmpresa>
									<cfset marcado = 1>
								<cfelse>
									<cfset marcado = 0>
								</cfif>
							</cfif>
						</cfif>

						<cfif band EQ 0>
							<tr>
							  <td width="51%" nowrap>
									<input <cfif marcado EQ 1> checked</cfif> type="checkbox" name="ckEmpresa" value="#EcodigoSDC#" style="border: '0'" class="areaFiltro">
									#HTMLEditFormat(Enombre)#
							  </td>					
							<cfset band = 1>					  
						<cfelse>
								<td width="49%" nowrap>
									<input <cfif marcado EQ 1> checked</cfif> type="checkbox" name="ckEmpresa" value="#EcodigoSDC#" style="border: '0'" class="areaFiltro">
									#HTMLEditFormat(Enombre)#
								</td>
							</tr>  
							<cfset band = 0>
						</cfif>
					<cfset marcado = 0>
				  </cfloop> 
					<tr>
						<td nowrap>&nbsp;						
						</td>
						<td nowrap>&nbsp;</td>							
					</tr>  					  
				</table>
			  </td>
              <td width="48%">
					<table width="100%" border="0">
                      <tr>
                        <td width="29%" nowrap><strong>Fecha de Inicio:</strong> </td>
                        <td width="71%">
							<cfif isdefined('form.fechaIni_f') and Len(Trim(form.fechaIni_f))>
								<cf_sifcalendario conexion="#session.DSN#" form="formFiltroEmpresas" name="fechaIni_f" value="#form.fechaIni_f#">
							<cfelse>
								<cf_sifcalendario conexion="#session.DSN#" form="formFiltroEmpresas" name="fechaIni_f" value="#fechaIni#">
							</cfif>						
						</td>
                      </tr>
                      <tr>
                        <td><strong>Fecha Final:</strong></td>
                        <td>
							<cfif isdefined('form.fechaFin_f') and Len(Trim(form.fechaFin_f))>
								<cf_sifcalendario conexion="#session.DSN#" form="formFiltroEmpresas" name="fechaFin_f" value="#form.fechaFin_f#">
							<cfelse>
								<cf_sifcalendario conexion="#session.DSN#" form="formFiltroEmpresas" name="fechaFin_f" value="#fechaFin#">
							</cfif>							
						</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>						
                      </tr>						  
                      <tr>
                        <td colspan="2"><input name="btnFiltrar" type="submit" id="btnFiltrar2" value="Consultar"></td>
                      </tr>					  
                    </table>			  
			  </td>
            </tr>
          </table>
	  </cfoutput>			
	</form>
	
	<cfif isdefined('form.btnFiltrar') and isdefined('form.ckEmpresa')>
		<table width="100%" border="0" align="center">
			<tr>
				<td>
					<cf_rhimprime datos="/sif/conscorp/Consultas/conscorp-form.cfm" paramsuri="&ckEmpresa=#form.ckEmpresa#&fechaIni_f=#form.fechaIni_f#&fechaFin_f=#form.fechaFin_f#">
                    <cfinclude template="conscorp-form.cfm">
				</td>
			</tr>
		</table>
	</cfif>

<script language="javascript" type="text/javascript">
	function marcarTodas(obj){
		for (var counter = 0; counter < obj.form.ckEmpresa.length; counter++)
			obj.form.ckEmpresa[counter].checked = obj.checked;
	}
	function validaFiltro(f){
		if(f.fechaIni_f.value == '' || f.fechaFin_f.value == ''){
			alert('Error, debe seleccionar el rango de fechas');
			return false;
		}else{
		   	var a = f.fechaIni_f.value.split("/");
			var fIni = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
		   	var b = f.fechaFin_f.value.split("/");
			var fFin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));			

			if(fIni > fFin){
				var temp = f.fechaIni_f.value;
				f.fechaIni_f.value = f.fechaFin_f.value;
				f.fechaFin_f.value = temp;
			}
		}
		var chequeado = false;
		for (var counter = 0; counter < f.ckEmpresa.length; counter++){
			if(f.ckEmpresa[counter].checked){
				chequeado = true;
				break;
			}
		}
		if(chequeado == false){
			alert('Error, debe seleccionar al menos una empresa de la Corporación');
			return false;
		}		
		
		return true;
	}
</script>