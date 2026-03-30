<!--- *************************************************** --->
<!--- ****      Query de la consulta                 **** --->
<!--- *************************************************** --->

	<cfquery name="rsDatos" datasource="#session.DSN#"  >			
		select b.Bid,Bdescripcion,CBid,CBdescripcion,CBcodigo,cb.Mcodigo,Mnombre
		from Bancos b
		inner join CuentasBancos cb
		   on cb.Ecodigo = b.Ecodigo
		  and cb.Bid = b.Bid
		inner join Monedas m
		   on m.Mcodigo = cb.Mcodigo
		where b.Ecodigo =  #Session.Ecodigo#
        	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> 
		order by  b.Bid,m.Mcodigo,CBid
	</cfquery>	

<!--- *************************************************** --->
<!--- ****      Area de pintado de la consulta       **** --->
<!--- *************************************************** --->
	<cfquery name="rsBancos" dbtype="query" >
		select distinct Bid, Bdescripcion 
		from rsDatos 
		order by Bdescripcion
	</cfquery>
	<cfif isdefined('form.datos') and LEN(TRIM(form.datos))>
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset Bid = Trim(arreglo[1])>	
		<cfset CBid = Trim(arreglo[2])>	
	
		<cfquery name="rsDatosCta" datasource="#session.DSN#">
			select CBcodigo, CBdescripcion,Bdescripcion,Oficodigo,Odescripcion,responsable
			from Bancos b
			inner join CuentasBancos cb
			   on cb.Ecodigo =  #Session.Ecodigo# 
			   and cb.Bid = b.Bid
			inner join Oficinas o
			   on cb.Ecodigo = o.Ecodigo
			  and cb.Ocodigo = o.Ocodigo
			where b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Bid#">
			  and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CBid#">
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>
	</cfif>
<cfoutput>
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
		<cf_templateheader title="Reporte Documentos Conciliados Independientemente">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" 
						titulo='Reporte de Documentos Preconciliados'>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td colspan="6">
								<cfinclude  template="../../portlets/pNavegacionMB.cfm">
							</td>
						</tr>	
					</table>
				<cfif isdefined('form.datos')>
					<form action="formDocConciliadosIndep.cfm" method="post" name="form1" onsubmit="return sinbotones()">
						<input name="Bid" type="hidden" value="#Bid#">
						<input name="CBid" type="hidden" value="#CBid#">
						
						<table border="0" cellpadding="0" cellspacing="0" align="center">
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr><td colspan="2"><font size="4">#rsDatosCta.Bdescripcion#</font></td></tr>
							<tr><td colspan="2"><font size="3">#trim(rsDatosCta.CBdescripcion)# - #trim(rsDatosCta.CBcodigo)#</font></td></tr>
							<tr><td colspan="2"><font size="3"><strong>Oficina:</strong> #rsDatosCta.Oficodigo# - #trim(rsDatosCta.Odescripcion)#</font></td></tr>
							<tr><td colspan="2"><font size="3"><strong>Responsable:</strong> #rsDatosCta.responsable#</font></td></tr>
							<tr>
								<td width="25%" nowrap><font size="2"><strong>Fecha del Estado de Cuenta:</strong></font>&nbsp;</td>
								<td width="75%"><cf_sifcalendario name="EChasta"></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td><font size="2">Consulta de Estados de Cuenta</font></td>
								<td>
								<cf_dbfunction name="to_sdateDMY"	args="EChasta" returnvariable="EChasta" >
									<cfset valuesArray = ArrayNew(1)>
									<cf_conlis 
											title="Lista de Estados de Cuenta"
											campos = "ECid, ECdescripcion" 
											desplegables = "N,N" 
											modificables = "N,N"
											size = "0,0"
											valuesarray="#valuesArray#" 
											tabla="ECuentaBancaria ec
													inner join CuentasBancos cb
													   on ec.CBid=cb.CBid
													inner join Bancos b
													   on cb.Bid = b.Bid
													  and cb.Ecodigo = b.Ecodigo"
											columnas="ec.Bid,ec.CBid,ec.ECid,ec.ECdescripcion,b.Bdescripcion, 
													  cb.CBdescripcion,ECdesde,#EChasta# as EChasta,ECdebitos,ECcreditos,ECsaldoini,ECsaldofin"
											filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and ec.Bid=$Bid,numeric$ and ec.CBid = $CBid,numeric$ and ECaplicado = 'S' and EChistorico = 'S'"
											desplegar="ECdescripcion,ECdebitos,ECcreditos,ECsaldoini,ECsaldofin"
											filtrar_por="ECdescripcion,ECdebitos,ECcreditos,ECsaldoini,ECsaldofin"
											etiquetas="Descripcion, D&eacute;bitos, Cr&eacute;ditos, Saldo Inicial,Saldo Final"
											formatos="S,M,M,M,M"
											align="left,right,right,right,right "
											asignar="ECid,ECdescripcion,EChasta"
											asignarformatos="I,S,D">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="2" align="center">
									<input type="submit" name="btnConsultar" value="Generar">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
					  </table>
					</form>
				<cfelse>
					<table width="100%" border="0" cellspacing="0" align="center">
						<form action="DocConciliadosIndep.cfm" method="post" name="form1">
							<input name="datos" type="hidden" value="">
						</form>
							<tr><td  nowrap colspan="3">&nbsp;</td></tr>
							<tr>
								<td>&nbsp;</td>
								<td  nowrap colspan="2"><font size="2"><strong>Seleccione una Cuenta para generar el reporte.</strong></font></td>
							</tr>
							<tr><td  nowrap colspan="3">&nbsp;</td></tr>
							<cfloop query="rsBancos">
								<cfset banco = #Bid#>	
								<tr bgcolor="CCCCCC">
									<td width="12%"  nowrap >&nbsp;</td>
									<td colspan="2"><b><font size="2">#rsBancos.Bdescripcion#</font></b></td>
								</tr>
								<cfquery name="rsCtas" dbtype="query" >
									select CBid, CBdescripcion, Mcodigo, Mnombre, CBcodigo
									from rsDatos 
									where Bid = #banco# 
									order by CBdescripcion
								</cfquery>
								<cfloop query="rsCtas">
									<cfset cta = #CBid#>	
									<tr height="15px"
											style="cursor: pointer;"
											onMouseOver="style.backgroundColor='##E4E8F3';" 
											onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" 
											onClick="javascript:consultar('#banco#|#cta#');">
										<td nowrap align="right">&nbsp;</td>
										<td width="30%" colspan="1">
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size="1"><strong>#rsCtas.CBdescripcion# - #rsCtas.Mnombre#</strong></font></td>
										<td width="58%"><font size="1"><strong>N de Cuenta:</strong> #CBcodigo#</font></td>
									</tr>
								</cfloop>
								<tr height="20px"><td colspan="3" nowrap align="right">&nbsp;</td></tr>
							</cfloop>
						
					</table>
				</cfif><cf_web_portlet_end>
			<cf_templatefooter>
</cfoutput>

<script language="JavaScript1.2">

// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	/*-------------------------*/		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	<cfif not isdefined('form.EChasta') and  isdefined('form.datos')>
	objForm.EChasta.required = true;
	objForm.EChasta.description = "Fecha del Estado de Cuenta";
	</cfif>
	function consultar(data) {
		if (data!="") {
			document.form1.action='DocConciliadosIndep.cfm';
			document.form1.datos.value=data;
			document.form1.submit();
		}
		return false;
	}
</script>
