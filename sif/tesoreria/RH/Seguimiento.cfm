 <cf_importLibs>
<cfinclude template="../../Utiles/sifConcat.cfm">

<!---- Periodo y Mes para los filtros. --->
<cfset Meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">

<!---►►Periodos--->
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	  select distinct Periodo as Speriodo
	  from RHEjecucion
	  where Ecodigo = #session.Ecodigo#
	  order by Periodo desc
</cfquery>

<!--- Ultimo año y mes calculado --->
<cfquery name="rsMaxPeriodo" datasource="#Session.DSN#">
	  select max(Periodo) as maxPeriodo
	  from RHEjecucion
	  where Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsMaxMes" datasource="#Session.DSN#">
	  Select max(Mes) as maxMes
	  From RHEjecucion 
	  where Ecodigo = #session.Ecodigo# and 
	  Periodo = #rsMaxPeriodo.maxPeriodo#
</cfquery>

<cfif not isDefined('form.Periodo') or not Len(Trim(form.Periodo))>
	<cfset form.Periodo = rsMaxPeriodo.maxPeriodo>
</cfif>

<cfif not isDefined('form.Mes') or not Len(Trim(form.Mes))>
	<cfset form.Mes = rsMaxMes.maxMes>
</cfif>

<cfif not isDefined('form.tipoConsulta') or not Len(Trim(form.tipoConsulta))>
	<cfset form.tipoConsulta = 'P'>
</cfif>

<cfquery name="rsTiposNomina" datasource="#session.dsn#">
	Select Tcodigo, Tdescripcion
	From TiposNomina
	Where Ecodigo = #session.Ecodigo#	
</cfquery>

<cfquery name="rsNominas" datasource="#session.dsn#">
	select no.ERNid, no.RCNid, no.HERNestado, tn.Tdescripcion, cp.CPdescripcion ,cp.CPtipo , cp.CPdesde, cp.CPhasta , no.Bid, 
		'<a href=''javascript: ConsultaNAP('#_Cat# <cf_dbfunction name="to_char" args="re.NAP_Compromiso" datasource="#session.dsn#"> #_Cat# ');''>' #_Cat#
				<cf_dbfunction name="to_char" args="re.NAP_Compromiso" datasource="#session.dsn#">	#_Cat#'</a>' as NAP_Compromiso,

		'<a href=''javascript: ConsultaNAP('#_Cat# <cf_dbfunction name="to_char" args="re.NAP" datasource="#session.dsn#">	#_Cat# ');''>' #_Cat#
				<cf_dbfunction name="to_char" args="re.NAP" datasource="#session.dsn#">	#_Cat#'</a>' as NAP_Ejecucion, 

		re.NapsDesCompromiso as NapsDesCompromiso,
		re.NapsPagadoLiquido as NapsPagadoLiquido,
		coalesce(re.IDcontable,re.IDcontableNoUni) as IDContableFinalizado,
		re.IDcontableLiquido

   	from HERNomina no
    	inner join TiposNomina tn 
        	on tn.Ecodigo  = no.Ecodigo
           and tn.Tcodigo  = no.Tcodigo
        inner join CalendarioPagos cp
        	on cp.CPid     = no.RCNid  
        inner join CuentasBancos ba
        	on ba.CBcc = no.CBcc
        left outer join EMovimientos em
        	on em.ERNid = no.ERNid
        inner join RHEjecucion re
        	on re.RCNid = no.RCNid
           and re.NAP_Compromiso is not null
    where no.Ecodigo    = #session.Ecodigo#
	  and no.HERNestado in (4,6) 
	  <cfif isdefined('form.Periodo') and Len(Trim(form.Periodo))>
	  	and re.Periodo = #form.Periodo#
	  </cfif>
	  <cfif isdefined('form.Mes') and Len(Trim(form.Mes))>
	  	and re.Mes = #form.Mes#
	  </cfif>
	  <cfif isdefined('form.Estado') and Len(Trim(form.Estado))>
	  	and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Estado#">
	  </cfif>
	group by no.ERNid, no.RCNid, no.HERNestado, tn.Tdescripcion, cp.CPdescripcion ,cp.CPtipo , cp.CPdesde, cp.CPhasta , no.Bid, 
	re.NAP_Compromiso, re.NAP , re.NapsDesCompromiso, re.NapsPagadoLiquido, re.IDcontable, re.IDcontableLiquido,re.IDcontableNoUni
	
	UNION ALL 
	
	select no.ERNid, no.RCNid, no.ERNestado, tn.Tdescripcion, cp.CPdescripcion ,cp.CPtipo , cp.CPdesde, cp.CPhasta , no.Bid,
	 	'<a href=''javascript: ConsultaNAP(' #_Cat# <cf_dbfunction name="to_char" args="re.NAP_Compromiso" datasource="#session.dsn#"> #_Cat# ');''>' 
	 			#_Cat# <cf_dbfunction name="to_char" args="re.NAP_Compromiso" datasource="#session.dsn#"> #_Cat#'</a>' as NAP_Compromiso, 

		'<a href=''javascript: ConsultaNAP(' #_Cat# <cf_dbfunction name="to_char" args="re.NAP" datasource="#session.dsn#"> #_Cat# ');''>' 
				#_Cat# <cf_dbfunction name="to_char" args="re.NAP" datasource="#session.dsn#"> #_Cat#'</a>' as NAP_Ejecucion, 

	 	re.NapsDesCompromiso as NapsDesCompromiso,
		re.NapsPagadoLiquido as NapsPagadoLiquido,
		coalesce(re.IDcontable,re.IDcontableNoUni) as IDContableFinalizado,
		re.IDcontableLiquido

	from ERNomina no
    	inner join TiposNomina tn 
        	on tn.Ecodigo  = no.Ecodigo
           and tn.Tcodigo  = no.Tcodigo
        inner join CalendarioPagos cp
        	on cp.CPid     = no.RCNid  
        inner join CuentasBancos ba
        	on ba.CBcc = no.CBcc
        left outer join EMovimientos em
        	on em.ERNid = no.ERNid
        inner join RHEjecucion re
        	on re.RCNid = no.RCNid
           and re.NAP_Compromiso is not null
    where no.Ecodigo    = #session.Ecodigo#
      <cfif isdefined('form.Periodo') and Len(Trim(form.Periodo))>
	  	and re.Periodo = #form.Periodo#
	  </cfif>
	  <cfif isdefined('form.Mes') and Len(Trim(form.Mes))>
	  	and re.Mes = #form.Mes#
	  </cfif>
	  <cfif isdefined('form.Estado') and Len(Trim(form.Estado))>
	  	and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Estado#">
	  </cfif>
	group by no.ERNid, no.RCNid, no.ERNestado, tn.Tdescripcion, cp.CPdescripcion ,cp.CPtipo , cp.CPdesde, cp.CPhasta , no.Bid, 
	re.NAP_Compromiso, re.NAP, re.NapsDesCompromiso, re.NapsPagadoLiquido,re.IDcontable, re.IDcontableLiquido,re.IDcontableNoUni
	order by cp.CPtipo
</cfquery>

<cf_templateheader title="Seguimiento de Nomina">
	<cf_web_portlet_start border="true" titulo="Seguimiento de Nomina" skin="#Session.Preferences.Skin#">

		<form id="formFiltros" name="formFiltros" method="post">
			<!--- Div de filtros --->
			<div id="Filtros" class="row Contenedor">
				<div class="col-xs-2 elementFiltro">
					<label>Período</label>
					<select name="Periodo" id="Periodo">
					    <cfloop query="rsPeriodos">
							<cfoutput><option value="#rsPeriodos.Speriodo#"
							<cfif isDefined('form.Periodo') and rsPeriodos.Speriodo EQ form.Periodo> selected </cfif>
							>#rsPeriodos.Speriodo#</option></cfoutput>
					    </cfloop>
				    </select>
				</div>
				<div class="col-xs-2 elementFiltro">
					<label>Mes</label>
					<select name="Mes" id="Mes" style="width:100px">
					  	<cfset numeroMes = 1>
					  	<cfloop list="#Meses#" index="i">
						   	<cfoutput><option value="#numeroMes#"
						   	<cfif isDefined('form.mes') and numeroMes EQ form.mes> selected </cfif>
						   	>#i#</option></cfoutput>
						   	<cfset numeroMes = numeroMes + 1>
					  	</cfloop>
					</select>
				</div>
				<div class="col-xs-3 elementFiltro">
					<label style="width:100px">Tipo de Nomina</label>
					<select id="Estado" name="Estado">
						<option value="" selected> -Todos- </option>
						<cfloop query="rsTiposNomina">
							<cfoutput><option value="#rsTiposNomina.Tcodigo#"
							<cfif isDefined('form.Tcodigo') and rsTiposNomina.Tcodigo EQ form.Tcodigo> selected </cfif>
							>#rsTiposNomina.Tdescripcion#</option></cfoutput>
					    </cfloop>
					</select>
				</div>

				<div class="col-xs-2 elementFiltro">
					<label style="width:100px">consultar</label>
					<select id="tipoConsulta" name="tipoConsulta">
						<cfoutput>
							<option value="P" <cfif isDefined('form.tipoConsulta') and form.tipoConsulta EQ 'P'> selected </cfif>>Presupuesto</option>
							<option value="C" <cfif isDefined('form.tipoConsulta') and form.tipoConsulta EQ 'C'> selected </cfif>>Contabilidad</option>
						</cfoutput>
					</select>
				</div>

				<div id="elementSubmit" class="col-xs-2">
					<input type="submit" value="Consultar" class="btn btn-primary"/>
				</div>
			</div>
		</form>

		<div class="row">
			<div class="col-xs-12">
				&nbsp;
			</div>
		</div>

		<cfif rsNominas.RecordCount>
			<cfoutput>
				<div class="table-responsive">
				  <table class="table table-bordered">
					<thead>
					  <tr class="colEncabezado">
						<td align="center" valign="middle">Nomina</td>
						<td align="center" valign="middle">Fecha</td>

						 <cfif form.tipoConsulta EQ 'P'>
						 	<td align="center" valign="middle">NAP compromiso<br />Total</td>
							<td align="center" valign="middle">NAP Devengo<br />Deduccciones</td>
							<td align="center" valign="middle">NAP Descompromiso<br />Liquido</td>
							<td align="center" valign="middle">NAP Pagado<br />Liquido</td>
	  					<cfelse>
	  						<td align="center" valign="middle">Finalización de<br />Nomina</td>
							<td align="center" valign="middle">Pago<br />Liquido</td>
	 					</cfif>
					  </tr>
					</thead>
					<tbody>
					<cfloop query="rsNominas">
						<tr>
							<td>
								<cfif rsNominas.CPtipo EQ 0>
									#rsNominas.Tdescripcion#
								<cfelseif rsNominas.CPtipo EQ 1>
									#rsNominas.CPdescripcion#
								<cfelse>
									Desconocido
								</cfif>
							</td>
							<td>
								#LSDATEFORMAT(rsNominas.CPdesde,'DD-MM-YYYY')#
								<cfif LSDATEFORMAT(rsNominas.CPdesde,'DD-MM-YYYY') NEQ  LSDATEFORMAT(rsNominas.CPhasta,'DD-MM-YYYY')>
								 al #LSDATEFORMAT(rsNominas.CPhasta,'DD-MM-YYYY')#
								</cfif>						
							</td>

							<cfif form.tipoConsulta EQ 'P'>
								<td>#rsNominas.NAP_Compromiso#</td>
								<td>#rsNominas.NAP_Ejecucion#</td>

								<td>
									<cfset DesCompromiso = rsNominas.NapsDesCompromiso>
									<cfset NAPDesCompromiso = DesCompromiso.split(",")>
									<cfloop index="NAP" array="#NAPDesCompromiso#"> 
										<a href="##" onclick='ConsultaNAP(#NAP#)'> #NAP# </a> 
									 </cfloop>
								</td>
								
								<td>
									<cfset pagadoLiquido = rsNominas.NapsPagadoLiquido>
									<cfset NAPPagadoLiquido = pagadoLiquido.split(",")>
									<cfloop index="NAP" array="#NAPPagadoLiquido#"> 
										<a href="##" onclick='ConsultaNAP(#NAP#)'> #NAP# </a> 
									 </cfloop>
								</td>
							<cfelse>
								<cfif trim(#rsNominas.IDContableFinalizado#) NEQ "">
									<cfquery name="rsPoliza" datasource="#session.dsn#">
										select Edocumento
										from EContables
										where IDcontable = #rsNominas.IDContableFinalizado#
									</cfquery>
								</cfif>
								<td><a href="##" onclick='ConsultaIDcontable(#rsNominas.IDContableFinalizado#)'> <cfif isDefined("rsPoliza.Edocumento") and rsNominas.IDContableFinalizado NEQ "">Póliza-#rsPoliza.Edocumento#</cfif></a></td>
								<td>
									<cfset contableLiquido = rsNominas.IDcontableLiquido>
									<cfset IDscontableLiquido = contableLiquido.split(",")>
									<cfloop index="ID" array="#IDscontableLiquido#">
										<cfif trim(ID) NEQ "" and trim(ID) neq "undefined">
											<cfquery name="rsPoliza2" datasource="#session.dsn#">
												select Edocumento
												from EContables
												where IDcontable = #ID#
											</cfquery>
										</cfif> 
										<a href="##" onclick='ConsultaIDcontable(#ID#)'><cfif isDefined("rsPoliza2.Edocumento") and trim(ID) NEQ "">Póliza-#rsPoliza2.Edocumento#</cfif></a> 
									 </cfloop>
								</td>
							</cfif>
						</tr>
					</cfloop>
					</tbody>
				  </table>
				</div>
			</cfoutput>
		<cfelse>
			<div class="row">
				<div class="col-xs-12 colDetalles">
					<strong>---No existen datos para la consulta---</strong>
				</div>
			</div>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- Estilos para la pantalla --->
<style type="text/css">
	.Contenedor{
		box-shadow: 0.1em 0.1em 2px blue;
		border-radius: 4px;
		margin: 0 4px 4px 4px;
		padding: 5px;
	}
	
	.elementFiltro{
		margin-left: 0.3em;
		margin-right: 0.3em;
	}
	.elementFiltro label{
		width: 150px;
		display: block;
		text-align: left;
		font-style: normal;
		font-weight: bold;
	}
	#elementSubmit{
		text-align: center;
	}
	#elementSubmit input{
		margin-left:10px;
		margin-top:5px;
	}
	.colEncabezado{
		background: #CADFE6;
		font-weight: bold;
		text-align: center;
	}
	.colEncabezado td{
		border-left: 1px solid #33CCCC;
		border-right: 1px solid #33CCCC;
	}
	.colDetalles{
		text-align: center;
	}
	.colDetalles:hover{
		background: beige;
		color:blueviolet;
		cursor:default;
	}
</style>

<script type="text/javascript">
	function ConsultaNAP(NAP)
	{	
		var param  = "NAP=" + NAP;
		location.href="../../presupuesto/consultas/ConsNAP.cfm?" + param;
	}

	function ConsultaIDcontable(ID)
	{	
		var param  = "ID=" + ID;
		location.href="../../cg/operacion/CDContables.cfm?VD=true&TC=2&RHN=1&" + param;
	}
</script>