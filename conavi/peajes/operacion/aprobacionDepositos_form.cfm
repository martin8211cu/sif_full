<cfif isdefined('url.modo') and len(trim(url.modo))>
	<cfset modo=url.modo>
</cfif>
<cfif isdefined('url.PDTDid') and len(trim(url.PDTDid))>
	<cfset form.PDTDid=url.PDTDid>
</cfif>
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
	 select Pvalor as periodo from Parametros
	 where Pcodigo = 50
	 and Ecodigo = #session.ecodigo# 
	</cfquery>

	<cfquery name="rsMes" datasource="#session.dsn#">
	 select Pvalor as MesAuxiliar from Parametros
	 where Pcodigo = 60
	 and Ecodigo = #session.ecodigo# 
	</cfquery>
	<cfset FechaAuxiliar = LsDateFormat(CreateDate(#rsPeriodo.periodo#,#rsMes.MesAuxiliar#,01),'dd/mm/YYYY')>
	
<cfif modo neq 'ALTA' and isdefined('form.PDTDid') and len(trim('form.PDTDid'))>
	<cfquery name="rsSelectDatosDepositos" datasource="#session.dsn#">
		select pdtd.PDTDid, p.Pid,  p.Pcodigo, pt.PTcodigo, pet.PETfecha, cf.Ocodigo, cb.CBid, m.Mcodigo, m.Mnombre, cb.CBcodigo, cb.CBdescripcion, pdtd.Mcodigo, pdtd.BTid, pdtd.PDTDmonto,
			pdtd.PDTDdocumento, pdtd.PDTDdescripcion, pdtd.PDTDtipocambio, b.Bid, b.Bdescripcion, pdtd.ts_rversion
		from PDTDeposito pdtd
			inner join CuentasBancos cb
				inner join Bancos b
					on cb.Bid = b.Bid and cb.Ecodigo = b.Ecodigo
				inner join Monedas m 
					on m.Mcodigo = cb.Mcodigo
				on cb.CBid = pdtd.CBid
			inner join PETransacciones pet
				inner join PTurnos pt
            		on pt.PTid = pet.PTid
				inner join Peaje p
        			on p.Pid = pet.Pid 
			on pet.PETid = pdtd.PETid 
              and pet.Ecodigo = #session.Ecodigo#
              inner join CFuncional cf
             	on cf.CFid = p.CFid
            	and cf.Ecodigo = p.Ecodigo
		where pdtd.PDTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PDTDid#">
        	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		order by pdtd.PDTDid
	</cfquery>
	<cfset CBid=rsSelectDatosDepositos.CBid>
	<cfset Mcodigo=rsSelectDatosDepositos.Mcodigo>
	<cfset BTid=rsSelectDatosDepositos.BTid>
	<cfset PDTDmonto=rsSelectDatosDepositos.PDTDmonto>
	<cfset PDTDdocumento=rsSelectDatosDepositos.PDTDdocumento>
	<cfset PDTDdescripcion=rsSelectDatosDepositos.PDTDdescripcion>
	<cfset PDTDtipocambio=rsSelectDatosDepositos.PDTDtipocambio>
	<cfset CBcodigo=rsSelectDatosDepositos.CBcodigo>
	<cfset CBdescripcion=rsSelectDatosDepositos.CBdescripcion>
	<cfset Bid=rsSelectDatosDepositos.Bid>
	<cfset Bdescripcion=rsSelectDatosDepositos.Bdescripcion>
	<cfset Mnombre=rsSelectDatosDepositos.Mnombre>
	
	<cfset PETfecha=rsSelectDatosDepositos.PETfecha>
	<cfset PTcodigo=rsSelectDatosDepositos.PTcodigo>
	<cfset Pcodigo=rsSelectDatosDepositos.Pcodigo>
	<cfset Pid=rsSelectDatosDepositos.Pid>
	
	<cfset Ocodigo=rsSelectDatosDepositos.Ocodigo>
	
<cfelse>
	<cfset Mcodigo=''>
	<cfset CBid=''>
	<cfset PDTDmonto='0'>
	<cfset PDTDdocumento=''>
	<cfset PDTDdescripcion=''>
	<cfset PDTDtipocambio='1'>
	<cfset Bid=''>
	<cfset Bdescripcion=''>
	<cfset CBcodigo=''>
	<cfset CBdescripcion=''>
	<cfset Mnombre=''>
	<cfset PETfecha=now()>
	<cfset PTcodigo=0>
	<cfset Pcodigo=0>
	<cfset Pid=0>
	<cfset Ocodigo=0>
</cfif>
<cfoutput>
<cfform action="aprobacionDepositos_SQL.cfm" method="post" name="form1">
	<table border="0" align="center" cellspacing="0" cellpadding="0" width="100%">
		<tr align="center"> 
			<td align="center" colspan="2"><strong>Detalles del Encabezado</strong></br></br></td>
		</tr>
		<tr align="center"> 
			<td align="center" colspan="2">
				<table align="center" border="0">
					<tr> 
						<td>Fecha Generación del Registro:</td>
						<td>
							<input name="fechaCreacion" id="fechaCreacion" value="#dateformat(PETfecha,'dd/mm/yyyy')#" readonly="yes">
						</td>
						<td nowrap align="right">&nbsp;&nbsp;</td>
						<td nowrap align="right">Peaje Asociado:</td>
						<td>
							<input name="peaje" id="peaje" value="#Pcodigo#" readonly="yes">
							<input name="peajeID" id="peajeID" value="#Pid#" readonly="yes" type="hidden">
						</td>
						<td nowrap align="right">&nbsp;&nbsp;</td>
						<td nowrap align="right">Turno Asociado:</td>
						<td>
							<input name="turno" id="turno" value="#PTcodigo#" readonly="yes">
						<td>
					</tr>
						<tr> 
						<td>
						<td>
					</tr>
					<tr>
				</table>
			</td>
		</tr>
		<tr align="center"> 
			<td align="center" colspan="2"><strong>Detalles del Dep&oacute;sito</strong></br></br></td>
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Fecha real del dep&oacute;sito:</strong></td>
			<td align="left">
				<cf_sifcalendario name="fecha" value="#dateformat(now(),'dd/mm/yyyy')#" tabindex="1" onChange="validaFecha()">
				<input type="hidden" name="fechaAuxiliar" value="#FechaAuxiliar#"/>
			</td>
		</tr>
		<tr> 
			<td width="50%" align="right"><strong>Documento:</strong></td>
			<td align="left">
				<input type="text" name="documento" value="#PDTDdocumento#">
			</td>
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Descripci&oacute;n:</strong></td>
			<td align="left">
				<input type="text" tabindex="1" name="descripcion" maxlength="120" size="40" value="#PDTDdescripcion#">
			</td>
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Banco:</strong></td>
			<td align="left">
				<input name="Bid" tabindex="1" value="#Bid#" readonly="yes" type="hidden">
				<input name="Bdescripcion" tabindex="1" value="#Bdescripcion#" readonly="yes">
			</td>
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Cuenta Bancaria: </strong></td>
			<td align="left">
				<input type="hidden" id="fechaCambio" name="fechaCambio" value="#now()#" />
				<cf_conlis title="Lista de Cuentas Bancarias"
				form="form3"
				campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
				values="#CBid#,#CBcodigo#,#CBdescripcion#,#Mcodigo#"
				desplegables = "N,S,S,N" 
				modificables = "N,N,N,N" 
				size = "0,0,40,0"
				tabla="
					CuentasBancos cb
					inner join Monedas m 
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo
					left outer join Htipocambio tc
					on 	tc.Ecodigo = cb.Ecodigo
					and tc.Mcodigo = cb.Mcodigo
					and tc.Hfecha  <= $fechaCambio,date$
					and tc.Hfechah >  $fechaCambio,date$ 
				"
				columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
				m.Mnombre,
				round(
				coalesce(
				(	case 
				when cb.Mcodigo = e.Mcodigo then 1.00 
				else tc.TCcompra 
				end
				)
				, 1.00)
				,2) as EMtipocambio"
				filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
				desplegar="CBcodigo, CBdescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
				asignarformatos="S,S,S,S,S,M"
				showEmptyListMsg="true"
				debug="false"
				readonly="yes"
				tabindex="1">
			</td><br />
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Moneda:</strong></td>
			<td align="left"><input type="text" name="Mnombre" value="#Mnombre#" readonly="yes" tabindex="-1"><br />
			</td>
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Tipo de Cambio:</strong></td>
			<td align="left">
				<cf_monto name="EMtipocambio" value="#PDTDtipocambio#" tabindex="-1" readonly="yes">
			</td>	
		</tr>
		<tr align="center"> 
			<td width="50%" align="right"><strong>Monto:</strong></td>
			<td align="left">
				<cf_monto name="monto" tabindex="-1" value="#PDTDmonto#">
			</td>	
		</tr>
		<tr align="center"> 
			<td colspan="2">
				 <cf_botones modo="#modo#" exclude="CAMBIO,BAJA,NUEVO" include="APROBAR,REGRESAR" includevalues="Aprobar Depósito,Regresar">
			</td>
		</tr>
		<tr align="center"> 
			<td colspan="2">
				<input type="hidden" id="Ecodigo" name="Ecodigo" value="#session.Ecodigo#" />
				<input type="hidden" id="MBUsucodigo" name="MBUsucodigo" value="#session.usucodigo#" />
				<input type="hidden" id="BTid" name="BTid" value="#BTid#" />
				<input type="hidden" id="tipoSocio" name="tipoSocio" value="0" />
				<input type="hidden" id="PDTDid" name="PDTDid" value="#form.PDTDid#" />
				<input type="hidden" id="Ocodigo" name="Ocodigo" value="#Ocodigo#" />
				<cfif modo neq "ALTA"  and isdefined('form.PDTDid') and len(trim('form.PDTDid'))>
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosDepositos.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
			</cfif>
			</td>	
		</tr>
	</table>
</cfform>
<cf_qforms>

<script language="javascript" type="text/javascript">
	objForm.fecha.description = "#JSStringFormat('Fecha Real del Depósito')#";
	objForm.fecha.required=true;
	objForm.documento.description = "#JSStringFormat('Documento del Depósito')#";
	objForm.documento.required=true;
	
	function funcREGRESAR(){
		location.href="listaAprobacionDepositos.cfm";
		return false;
	}
	function validaFecha()
	{	  	 
	if(fnFechaYYYYMMDD (document.form1.fecha.value) < fnFechaYYYYMMDD (document.form1.fechaAuxiliar.value))
	{
	   alert("La fecha que esta ingresando es menor a la fecha del Periodo Auxiliar");
	   document.form1.fecha.value ='';
	 }
	}		
	function fnFechaYYYYMMDD(f1)
	{
		return f1.substr(6,4) + f1.substr(3,2) + f1.substr(0,2);
	}	
	
</script>
</cfoutput>