<!--- 
	Modificado por Gustavo Fonseca. 
	Fecha: 18-1-2006.
	Motivo: se corrige el mensaje de página expirada al utilizar el link de REGRESAR, pues usaba la 
	función "backREG". se usa un "formsql" con el action hacia la página de inicio del proceso y se pone Abril en vez de Abrril.
--->
<cfif not IsDefined("intercomp")>
	<cfset intercomp=0>
</cfif>
<cfif isdefined("url.tipoCuentaReporte") and not isdefined("form.tipoCuentaReporte")>
	<cfset form.tipoCuentaReporte = url.tipoCuentaReporte>
</cfif>
<cfif not isdefined("form.tipoCuentaReporte") or ( isdefined("form.tipoCuentaReporte") and len(trim(form.tipoCuentaReporte)) EQ 0)>
	<cfset form.tipoCuentaReporte ="CC">
</cfif>

<cfset LvarNivs = -1>
<cfif isdefined("url.cboNivs") and isnumeric(url.cboNivs)>
	<cfset LvarNivs = url.cboNivs>
</cfif>
<script language="javascript1.2" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function funcObjetos(paramvalor){
		popUpWindow('ObjetosDocumentosCons.cfm?IDcontable='+paramvalor,200,100,700,500);
	}
</script>

<cfif isDefined('Form.Tabla') and (#Form.Tabla# EQ 'HDContables' OR #Form.Tabla# EQ 'HDContables1')>
	<cfset Tabla = 'HDContables'>
<cfelse>
	<cfset Tabla = 'DContables'>
</cfif>    

<!--- Se determina el tipo de tabla donde se capturarán los datos--->
<cfif #Tabla# EQ 'HDContables'>
	<cfset LVarEncabezado = 'HEContables'>
    <cfset LVarUsuario = 'ECusucodigoaplica'> 
    <cfset LVarFecha = 'ECfechaaplica'>
    <cfset LVarEncTipo = 'Asiento Aplicado'>
<cfelse>
	<cfset LVarEncabezado = 'EContables'>	
    <cfset LVarUsuario = 'ECusucodigo'>
    <cfset LVarFecha = 'Efecha'>
    <cfset LVarEncTipo = 'Asiento en Tr&aacute;nsito'>
</cfif>

<cfquery name="rsPerMes" datasource="#Session.DSN#">
	select a.Eperiodo, a.Emes, a.Edescripcion, a.Cconcepto, a.Edocumento, a.Efecha, a.Ereferencia, a.Edocbase, a.ECtipo
	from #LVarEncabezado# a
		<cfif intercomp EQ 1>
			INNER JOIN EControlDocInt ei on ei.idcontableori=a.IDcontable
			INNER JOIN HDContablesInt hdi on hdi.IDcontable=a.IDcontable
			and ei.idcontableori=hdi.IDcontable
		</cfif>
	where <cfif intercomp EQ 1>ei<cfelse>a</cfif>.Ecodigo = #Session.Ecodigo#
	and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
</cfquery>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsDatosPersonales" datasource="#Session.DSN#">
	select <cf_dbfunction name="sPart" args="rtrim(ltrim(g.Pnombre))#_Cat#' '#_Cat#rtrim(ltrim(g.Papellido1))#_Cat#' '#_Cat#rtrim(ltrim(g.Papellido2)); 1; 50" delimiters=";"> as Pnombre,
	e.#LVarFecha#,  e.#LVarUsuario#
	from #LVarEncabezado# e
		inner join Usuario f
        	<cfif #Tabla# EQ 'HDContables'>
				on e.#LVarUsuario# =  f.Usucodigo
           	<cfelse>
            	on e.#LVarUsuario# = f.Usucodigo
            </cfif>
		inner join DatosPersonales g
			on f.datos_personales = g.datos_personales
	where e.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
</cfquery>

<cfif isdefined("rsDatosPersonales") and rsDatosPersonales.RecordCount NEQ 0>
	<cfset NombreAplica = rsDatosPersonales.Pnombre>
    <cfif #LVarUsuario# EQ 'ECusucodigoaplica'>
		<cfset FechaAplica = rsDatosPersonales.ECfechaaplica>
    <cfelse>
    	<cfset FechaAplica = rsDatosPersonales.Efecha>
    </cfif>
	<cfelse>
	<cfset NombreAplica =  ''>
	<cfset FechaAplica =  ''>
</cfif>

<cfparam name="Form.Ccuenta" default="">

<cfinclude template="Funciones.cfm">

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfsavecontent variable="myquery">
	<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">
	<cfoutput>
		<cfif not isdefined("url.Export")>
			select distinct
			a.IDcontable, 
			a.Dlinea, 
			a.Ecodigo, 
			a.Eperiodo, 
			a.Emes as Emes, 
			a.Cconcepto as CconceptoQuery, 
			a.Edocumento, 
			a.Ocodigo,
			d.Oficodigo, 
			a.Ddescripcion , 
			a.Ddocumento, 
			a.Dreferencia, 
			case when Dmovimiento='D' then 'Debito' else 'Credito' end as DMovimiento, 
			Dmovimiento as tipoMov,
			a.Ccuenta,
			<cfif isdefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CF">
				cfi.CFformato as Cformato,
				cfi.CFdescripcion as Cdescripcion,
			<cfelseif isdefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CC">
				b.Cformato,
				b.Cdescripcion,
			<cfelse>
				b.Cformato,
				b.Cdescripcion,
			</cfif>			
			a.Doriginal, 
			a.Dlocal, 
			c.Mnombre, 
			a.Dtipocambio,
			case when cf.CFid is not null then
				rtrim(cf.CFcodigo) #_CAT# '-' #_CAT# rtrim(cf.CFdescripcion)
			else
				''
			end
			as CentroFuncional,
			(select Edescripcion from Empresas where Ecodigo=cfi.Ecodigo) as empresa
			from 
				<cfif intercomp EQ 1 and #Tabla# EQ 'HDContables'>
					HDContablesInt a
					INNER JOIN EControlDocInt ei on ei.idcontableori=a.IDcontable
					INNER JOIN HEContables he on he.IDcontable=a.IDcontable
					and ei.idcontableori=he.IDcontable
				<cfelse>
					#Tabla# a
				</cfif>
				inner join CContables b
					on b.Ccuenta = a.Ccuenta
				inner join Monedas c
					on c.Mcodigo = a.Mcodigo
				left join Oficinas d
					on d.Ecodigo = a.Ecodigo
					and d.Ocodigo = a.Ocodigo
				left outer join CFinanciera cfi
                      on cfi.CFcuenta = a.CFcuenta
				left outer join CFuncional  cf
						on cf.CFid = a.CFid						
			where a.IDcontable = #Form.IDcontable#
		<cfelse>
			select distinct
				a.Eperiodo as Periodo, 
				a.Emes as Mes, 
				a.Cconcepto as Concepto, 
				a.Edocumento as Documento_Encabezado, 
				d.Oficodigo as Oficina, 
				a.Ddescripcion as Descripcion, 
				a.Ddocumento as Documento, 
				a.Dreferencia as Referencia, 
				case when Dmovimiento='D' then 'Debito' else 'Credito' end as Movimiento, 
				Dmovimiento as Tipo_Mov,
				<cfif isdefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CF">
					cfi.Cformato as Cuenta_Formato, 
					cfi.Cdescripcion as DescCuenta,
				<cfelseif isdefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CC">
					b.Cformato as Cuenta_Formato, 
					b.Cdescripcion as DescCuenta,
				<cfelse>
					b.Cformato as Cuenta_Formato, 
					b.Cdescripcion as DescCuenta,
				</cfif>
				
				(select Edescripcion from Empresas where Ecodigo=cfi.Ecodigo) as empresa,
				a.Doriginal as Original, 
				a.Dlocal as Local, 
				c.Mnombre as Moneda, 
				a.Dtipocambio as Tipo_Cambio,
				case when cf.CFid is not null then
				rtrim(cf.CFcodigo) #_CAT# '-' #_CAT# rtrim(cf.CFdescripcion)
				else
					''
				end
				as CentroFuncional				
				from 
					<cfif intercomp EQ 1 and #Tabla# EQ 'HDContables'>
						HDContablesInt a
						INNER JOIN EControlDocInt ei on ei.idcontableori=a.IDcontable
						INNER JOIN HEContables he on he.IDcontable=a.IDcontable
						and ei.idcontableori=he.IDcontable
				<cfelse>
					#Tabla# a
				</cfif>
					inner join CContables b
						on b.Ccuenta = a.Ccuenta
					inner join Monedas c
						on c.Mcodigo = a.Mcodigo
					inner join Oficinas d
						on d.Ecodigo = a.Ecodigo
						and d.Ocodigo = a.Ocodigo
					left outer join CFinanciera cfi
                      on cfi.CFcuenta = a.CFcuenta
					left outer join CFuncional  cf
						on cf.CFid = a.CFid
			where a.IDcontable = #Form.IDcontable#
		</cfif>
	</cfoutput>
</cfsavecontent>

<cfquery name="rsParametro" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 981
</cfquery>
<cfset LvarParametro = 0>
<cfif isdefined("rsParametro") and rsParametro.recordcount eq 1>
		<cfset LvarParametro= rsParametro.Pvalor>
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaContable = t.Translate('PolizaContable','P&oacute;liza Contable')>
<cfset ConsPolCont = t.Translate('ConsPolCont','Consulta de P&oacute;lizas Contables')>
<cfset Msg_AsientoGenInter = t.Translate('Msg_AsientoGenInter','El Asiento Fue Generado a Partir de un Intercompa&ntilde;&iacute;a')>
<cfset Btn_DocsSop = t.Translate('Btn_DocsSop','Docs. Soporte')>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
</style>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr>
			<td colspan="15" align="center"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr>
			<td colspan="15" class="subTitulo" align="center"><strong>#ConsPolCont#</strong></td>
		</tr>
		<tr>
			<td colspan="15" class="subTitulo" align="center"><strong>#LVarEncTipo#</strong></td>
		</tr>        
		<tr>
			<td colspan="15" align="center">&nbsp; </td>
		</tr>
		<cfif not isdefined('url.export')>
			<cfif GetFileFromPath(GetTemplatePath()) NEQ 'PolizaContaImpr.cfm'>
				<tr>
					<td colspan="15" align="right">
						<input type="button" name="btnObjetos" value="#Btn_DocsSop#" onClick="javascript: funcObjetos(#Form.IDcontable#);">
					</td>
				</tr>
			</cfif>
		</cfif>
		
		<cfquery name="rsPadre" datasource="#session.DSN#">
			select  distinct
			h.Edocumento as poliza,
			h.Edescripcion as descripcion,
			h.Edocbase as doc,
			h.Ereferencia as ref,
			h.Eperiodo as periodo,
			h.Emes as mes,
			h.ECfechacreacion as creado,
			h.ECfechaaplica as aplicado


			from EControlDocInt r 
				inner join HEContables h on h.IDcontable=r.idcontableori
				inner join HDContablesInt hdi on hdi.IDcontable = r.idcontableori
			where r.Ecodigodest= #Session.Ecodigo#
			and r.Idcontabledest = #Form.IDcontable#
		</cfquery>
		<cfif rsPadre.RecordCount GT 0 >
		<tr>
			<td colspan="16">&nbsp; </td>
		</tr>
		<tr>
			<td colspan="16" nowrap="nowrap" style=" padding:10px 5px; background:##F2F2F2;">#Msg_AsientoGenInter# <b><cf_translate key=LB_Poliza>P&oacute;liza</cf_translate>:</b> #rsPadre.poliza#  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate>:</b> #rsPadre.descripcion#  
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><cf_translate key=LB_Ref>Ref</cf_translate>:</b> #rsPadre.ref# 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><cf_translate key=LB_Doc>Doc</cf_translate>:</b> #rsPadre.doc# 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><cf_translate key=LB_Periodo>Periodo</cf_translate>:</b> #rsPadre.periodo# - #rsPadre.mes# </td>
		</tr>
		<tr>
			<td colspan="16">&nbsp; </td>
		</tr>
		</cfif>
	
	</cfoutput>
</cfsavecontent>	
<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
 
<cfquery name="rsDocumento" datasource="#session.DSN#">
	select count(1) as cantidad
	from #LVarEncabezado#
	where IDcontable = #Form.IDcontable#
</cfquery>
<cfif IsDefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CF">
	<form name="form1" method="post" action="saldosymov02CF.cfm">
<cfelse>
	<form name="form1" method="post" action="saldosymov02.cfm">
</cfif>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif rsDocumento.cantidad EQ 0>
			<cfoutput>#encabezado1#</cfoutput>
		</cfif>		
		<cfset Lvarcontador = 0>
        <cftry>
            <cfquery name="rsProc" datasource="#session.dsn#">
                #preservesinglequotes(myquery)#<!--- # --->
            </cfquery>
            <cfcatch type="any">
                <cfrethrow>
            </cfcatch>
        </cftry>
         <cfif isdefined("url.Export")>
                <cfset Lvarnombre = "PolizaContable_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
                <cf_exportQueryToFile query="#rsProc#" filename="#Lvarnombre#" jdbc="false">
        </cfif>
        <cfflush interval="32">
		
        <cfoutput query="rsProc"> 
			<cfif currentRow mod 40 EQ 1>
				<cfif currentRow NEQ 1>
					<tr class="pageEnd"><td colspan="15">&nbsp;</td></tr>
				</cfif>
				#encabezado1#
				<tr>
					<td colspan="15"  nowrap>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:15%"><font size="2"><cf_translate key=LB_Periodo>Periodo</cf_translate>:</font></td>
								<td colspan="4"><font size="2"><strong>#ListGetAt(meses, rsPermes.Emes, ',')#&nbsp;#rsPerMes.Eperiodo#</strong></font></td>
							</tr>

							<tr>
								<td><font size="2">#PolizaContable#:</font></td>
								<td colspan="3"><font size="2"><strong>#CconceptoQuery# - #Edocumento#</strong></font></td>
								<td><font size="2"><cf_translate key=LB_FecDoc>Fecha Documento</cf_translate>: <strong>#dateformat(rsPerMes.Efecha, 'dd/mm/yyyy')#</strong></font></td>

							</tr>
							<tr>
								<td><font size="2"><cf_translate key=LB_Referencia>Referencia</cf_translate>:</font></td>
								<td colspan="3"><strong>#rsPerMes.Ereferencia#</strong></td>
								<td><font size="2"><cf_translate key=LB_DocBase>Documento Base</cf_translate>:&nbsp;&nbsp;&nbsp;<strong>#rsPerMes.Edocbase#</strong></font></td>
							</tr>					
							<tr>
								<td><font size="2"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate>:</font></td>
								<td colspan="4"><strong>#rsPerMes.Edescripcion#</strong></td>
							</tr>					
							<tr>
								<td><font size="2"><cf_translate key=LB_Usuario>Usuario</cf_translate>:</font></td>
								<td colspan="4"><font size="2"><strong><cfif len(NombreAplica)>#NombreAplica#<cfelse>Sin definir</cfif> (<cfif len(FechaAplica)>#dateformat(FechaAplica, 'dd/mm/yyyy')#<cfelse>&nbsp;</cfif>)</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>	
				<tr>			
					<td colspan="15"  nowrap  style="padding-right: 20px">&nbsp;</td>
				</tr>		
				<tr bgcolor="##E4E4E4">
					<td align="left" width="94" ><font size="2"><cf_translate key=LB_Linea>L&iacute;nea</cf_translate></font></td>
					<td width="23">&nbsp;</td>
					<td width="280"><font size="2"><cf_translate key=LB_Cuenta>Cuenta</cf_translate></font></td>
					<cfif LvarParametro>
						<td width="280"><font size="2"><cf_translate key=LB_DescCuenta>Desc. Cuenta</cf_translate></font></td>
					</cfif>
					<cfif intercomp EQ 1>
						<td ><font size="2"><cf_translate key=LB_Empresa>Empresa</cf_translate></font></td>
					</cfif>
					<td width="127"><font size="2"><cf_translate key=LB_Oficina>Oficina</cf_translate></font></td>
					<td width="13">&nbsp;</td>
					<td width="614"><font size="2"><cf_translate key=LB_CentrFunc>Centro Funcional</cf_translate></font></td>
					<td>&nbsp;</td>
					<td width="614" align="left"><font size="2"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></font></td>
					<td nowrap align="right"><font size="2"><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></font></td>
					<td width="1%" align="left">&nbsp;</td>
					<td nowrap align="right"><font size="2"><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></font></td>
					<td width="1">&nbsp;</td>
					<td width="111" align="right"><font size="2"><cf_translate key=LB_Moneda>Moneda</cf_translate></font></td>
					<td width="1">&nbsp;</td>
					<td width="105" align="right" nowrap><font size="2"><cf_translate key=LB_MontoOri>Monto Origen</cf_translate></font></td>
				</tr>
			</cfif>				
			<tr <cfif Form.CCuenta EQ Ccuenta>style="font-weight:bold"</cfif>>
				<td >
					#Dlinea#
				</td>
				<td>&nbsp;</td>
				<td nowrap>
					#fnNiveles(Cformato)#&nbsp;&nbsp;
				</td>
				<cfif LvarParametro>
					<td>
						#Cdescripcion#
					</td>
				</cfif>
				<cfif intercomp EQ 1>
					<td width="250" style="cursor:pointer;" alt="#empresa#" title="#empresa#" >#left(empresa,10)#...</td>
				</cfif>
				<td>#Oficodigo#</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>
					<cfif len(CentroFuncional) GT 35>
						#Mid(CentroFuncional,1,35)#...
					<cfelse>
						#CentroFuncional#
					</cfif>
				</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>
					<cfif len(Ddescripcion) GT 35>
						#Mid(Ddescripcion,1,35)#...
					<cfelse>
						#Ddescripcion#
					</cfif>
				</td>
				<td align="right" nowrap>
					<cfif Dmovimiento EQ "Debito">
						#LSCurrencyFormat(DLocal,'none')#
					<cfelse>
						#LSCurrencyFormat(0,'none')#
					</cfif>
				</td>
				<td>&nbsp;</td>
				<td nowrap align="right">
					<cfif #Dmovimiento# EQ "Credito">
						#LSCurrencyFormat(Dlocal,'none')#
					<cfelse>
						#LSCurrencyFormat(0,'none')#
					</cfif>
				</td>
				<td>&nbsp;</td>
				<td  align="right" nowrap>
					#Mnombre# 
				</td>
				<td>&nbsp;</td>
				<td align="right">
					#LSCUrrencyFormat(Doriginal,'none')#
				</td>
			</tr>
		</cfoutput>
		<tr>
			<td colspan="<cfif LvarParametro>9<cfelse>8</cfif>">&nbsp;</td>
			<td align="right" nowrap>--------------------</td>
			<td>&nbsp;</td>
			<td align="right" nowrap>--------------------</td>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<cfquery name="rsTotDebCre" datasource="#session.DSN#">
				select 
					sum(case when Dmovimiento = 'D' then Dlocal else 0.00 end) as Debitos,
					sum(case when Dmovimiento = 'C' then Dlocal else 0.00 end) as Creditos
				from HDContables 
				where IDcontable = #form.IDcontable# 
			</cfquery>
			
			<td colspan="<cfif LvarParametro>8<cfelse>7</cfif>">&nbsp;</td>
			<td align="right"><strong><cfoutput><cf_translate key=LB_Total>Total</cf_translate></cfoutput>:</strong></td>
			<td nowrap align="right">
				<strong><cfoutput>#LSCurrencyFormat(rsTotDebCre.Debitos,'none')#</cfoutput></strong>
			</td>
			<td>&nbsp;</td>
			<td align="right" nowrap>
				<strong><cfoutput>#LSCurrencyFormat(rsTotDebCre.Creditos,'none')#</cfoutput></strong>
			</td>
			<td colspan="6">&nbsp;</td>
		</tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr>
			<TD colspan="15" align="center">_________________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_________________________</TD>
		</tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		
		<cfif intercomp EQ 1>
			<tr><td align="center" colspan="16" style="font-size:12px;font-weight:bold;"><cf_translate key=LB_AsientosGen>Asientos generados</cf_translate><br/><br/></td></tr>
			<!--- asiento generado en la empresa local (EMPRESA A)--->
			<!--- ENCABEZADO--->
			<cfquery name="rsAsientosGeneradosEnc" datasource="#session.DSN#">			
				select  distinct
					e.IDcontable,e.Cconcepto as Concepto, e.Edocumento as Documento, e.Efecha as Fecha, 
					e.Eperiodo as Periodo, e.Emes as Mes, e.ECauxiliar as Auxiliar, e.ECusuario as Usuario, e.ECfechacreacion,
					e.ECfechaaplica,e.Edescripcion,e.Ereferencia as ref, e.Edocbase,e.Oorigen, c.Cdescripcion as DescripcionConcepto 
				from HEContables e				
				   inner join ConceptoContableE c on c.Ecodigo = e.Ecodigo
					 and c.Cconcepto = e.Cconcepto 	
				where e.Ecodigo = #session.Ecodigo#			
					and e.IDcontable = #form.IDcontable#
			</cfquery>
			<cfif rsAsientosGeneradosEnc.recordcount GT 0>
			
			<tr><td colspan="16">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfoutput query="rsAsientosGeneradosEnc">
					<tr><td style="font-weight:bold;" colspan="11"><cf_translate key=LB_EstApl>Est&aacute; Aplicado</cf_translate></td></tr>
					<tr bgcolor="##f2f2f2" style="font-weight:bold;">
						<td nowrap="nowrap" colspan="2" style="padding:10px 5px;"><cf_translate key=LB_Poliza>P&oacute;liza</cf_translate>&nbsp;#rsAsientosGeneradosEnc.Documento#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_FDoc>Fecha Doc</cf_translate>:&nbsp;#dateformat(rsAsientosGeneradosEnc.Fecha,'dd/mm/yyyy')#</td>
						<td nowrap="nowrap" colspan="3" style="padding:10px 5px;"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.Edescripcion#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_Ref>Ref</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.ref#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_Doc>Doc</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.Edocbase#</td>
						<td nowrap="nowrap" style="padding:10px 5px;">Año:&nbsp;#rsAsientosGeneradosEnc.Periodo#</td>
						<td nowrap="nowrap" style="padding:10px 5px;">Mes:&nbsp;#rsAsientosGeneradosEnc.Mes#</td>	
						<td></td>
					</tr>
					<tr bgcolor="##fafafa" style="font-wight:bold;">
						<td>Linea</td>
						<td><cf_translate key=LB_Oficina>Oficina</cf_translate></td>
						<td><cf_translate key=LB_Documento>Documento</cf_translate></td>
						<td><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></td>
						<td><cf_translate key=LB_Ref>Ref</cf_translate></td>
						<td><cf_translate key=LB_Cuenta>Cuenta</cf_translate></td>
						<td nowrap="nowrap"><cf_translate key=LB_DescCuenta>Desc. Cuenta</cf_translate></td>
						<td nowrap="nowrap"><cf_translate key=LB_Empresa>Empresa</cf_translate></td>						
						<td nowrap="nowrap" align="right"><cf_translate key=LB_MontoOriginal>Monto Original</cf_translate></td>
						<td align="right"><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></td>
						<td align="right"><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></td>
					</tr>
				<!--- detalle de asiento originado--->
					<cfquery name="rsRepDori" datasource="#session.DSN#">
							select distinct d.Dlinea as Linea,d.Ddocumento as Documento,
							d.Ddescripcion as Descripcion, d.Dreferencia as Referencia,
							<cfif isdefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CF">
								cf.CFformato as Cuenta, 
								cf.CFdescripcion as DescCuenta,
							<cfelseif isdefined("form.tipoCuentaReporte") and form.tipoCuentaReporte EQ "CC">
								cc.Cformato as Cuenta, 
								cc.Cdescripcion as DescCuenta,
							<cfelse>
								cc.Cformato as Cuenta, 
								cc.Cdescripcion as DescCuenta,
							</cfif>			
							
							o.Oficodigo as Oficina, coalesce(d.Doriginal, 1) as  Monto,
							m.Msimbolo as Moneda, coalesce(d.Dtipocambio, 1) as	 TipoCambio, 
							case when d.Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
							case when d.Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
							m.Miso4217, (select e.Edescripcion from Empresas e where Ecodigo=cf.Ecodigo) as empresa
						from 
							HDContables d
							inner join CFinanciera cf on cf.CFcuenta = d.CFcuenta
							inner join CContables cc on cc.Ccuenta = d.Ccuenta
							inner join Monedas m on m.Mcodigo = d.Mcodigo
							inner join Oficinas o on o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo
						where d.IDcontable=#rsAsientosGeneradosEnc.IDcontable# and d.Ecodigo = #session.Ecodigo#
					</cfquery>
					<cfloop query="rsRepDori">
                    <tr>
                        <td>#rsRepDori.Linea#</td><td>#rsRepDori.Oficina#</td><td>#rsRepDori.Documento#</td> 
						<td>#rsRepDori.Descripcion#</td><td>#rsRepDori.Referencia#</td><td>#rsRepDori.Cuenta#</td>
                        <td nowrap="nowrap">#rsRepDori.DescCuenta#</td>
						<td nowrap="nowrap"><span style="cursor:pointer;" alt="#rsRepDori.empresa#" title="#rsRepDori.empresa#" >#Left(empresa, 12)#</span></td>
                        <td nowrap="nowrap" align="right">#numberformat(rsRepDori.Monto,',_.__')#</td>
                        <td align="right">#numberformat(rsRepDori.Debitos,',_.__')#</td> <td align="right">#numberformat(rsRepDori.Creditos,',_.__')#</td>
                    </tr>                    
					</cfloop>
				</cfoutput>				
				</table>
				<br/><br/>
			</td></tr>
			</cfif>
			
			<!--- asientos generados en las otras empresas  (EMPRESA B)--->
			<cfquery name="rsAsientosGeneradosEnc" datasource="#session.DSN#">			
				SELECT DISTINCT
							he.IDcontable,
							CASE 
								WHEN ((e.IDcontable IS NULL) AND (he.IDcontable IS NULL)) THEN '-1'
								WHEN he.IDcontable IS NOT NULL THEN '1'
								WHEN e.IDcontable IS NOT NULL THEN '0' END as aplicado,
							ei.ECid,
							ei.Idcontabledest,
							ei.idcontableori,
							ei.Ecodigodest,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Cconcepto
								WHEN e.IDcontable IS NOT NULL THEN e.Cconcepto END as Cconcepto,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Edocumento
								WHEN e.IDcontable IS NOT NULL THEN e.Edocumento END as Documento,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Efecha
								WHEN e.IDcontable IS NOT NULL THEN e.Efecha END as Fecha,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Eperiodo
								WHEN e.IDcontable IS NOT NULL THEN e.Eperiodo END as Periodo,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Emes
								WHEN e.IDcontable IS NOT NULL THEN e.Emes END as Mes,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.ECauxiliar
								WHEN e.IDcontable IS NOT NULL THEN e.ECauxiliar END as Auxiliar,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.ECusuario
								WHEN e.IDcontable IS NOT NULL THEN e.ECusuario END as Usuario,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.ECfechacreacion
								WHEN e.IDcontable IS NOT NULL THEN e.ECfechacreacion END as ECfechacreacion,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Edescripcion
								WHEN e.IDcontable IS NOT NULL THEN e.Edescripcion END as Edescripcion,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Ereferencia
								WHEN e.IDcontable IS NOT NULL THEN e.Ereferencia END as ref,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Edocbase
								WHEN e.IDcontable IS NOT NULL THEN e.Edocbase END as Edocbase,
							CASE 
								WHEN he.IDcontable IS NOT NULL THEN he.Oorigen
								WHEN e.IDcontable IS NOT NULL THEN e.Oorigen END as Oorigen,
							u.Usulogin as UsuarioAplica,
							c.Cdescripcion as DescripcionConcepto 
														
						FROM
							EControlDocInt ei
							INNER JOIN HDContablesInt hdi on hdi.IDcontable=ei.idcontableori
							
							LEFT OUTER JOIN HEContables he 
								ON he.IDcontable = ei.Idcontabledest								
							LEFT OUTER JOIN EContables e
							ON e.IDcontable = ei.Idcontabledest
							
							LEFT JOIN ConceptoContableE c
								on c.Ecodigo 	 = e.Ecodigo
								and c.Cconcepto = e.Cconcepto
								and c.Cconcepto = he.Cconcepto
								LEFT JOIN Usuario u
								on u.Usucodigo = e.BMUsucodigo and u.Usucodigo = he.BMUsucodigo
						WHERE
							ei.Ecodigo = #session.Ecodigo#
							AND ei.idcontableori = #Form.IDcontable#
			</cfquery>
			<cfif rsAsientosGeneradosEnc.recordcount GT 0>	
				<tr><td colspan="16">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfoutput query="rsAsientosGeneradosEnc">
					<tr>
					<cfif rsAsientosGeneradosEnc.aplicado EQ "0"><td colspan="11" style="font-weight:bold;color:red;"><cf_translate key=LB_NoEstaApl>No est&aacute; Aplicado</cf_translate></td>
					<cfelse><td style="font-weight:bold;" colspan="11"><cf_translate key=LB_EstApl>Est&aacute; Aplicado</cf_translate></td></cfif></tr>
					<tr bgcolor="##f2f2f2" style="font-weight:bold;">						
						<td nowrap="nowrap" colspan="2" style="padding:10px 5px;"><cf_translate key=LB_Poliza>P&oacute;liza</cf_translate>&nbsp;#rsAsientosGeneradosEnc.Documento#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_FDoc>Fecha Doc</cf_translate>:&nbsp;#dateformat(rsAsientosGeneradosEnc.Fecha,'dd/mm/yyyy')#</td>
						<td nowrap="nowrap" colspan="3" style="padding:10px 5px;"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.Edescripcion#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_Ref>Ref</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.ref#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_Doc>Doc</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.Edocbase#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_Anio>Año</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.Periodo#</td>
						<td nowrap="nowrap" style="padding:10px 5px;"><cf_translate key=LB_Mes>Mes</cf_translate>:&nbsp;#rsAsientosGeneradosEnc.Mes#</td>
						<td></td>
					</tr>
					<tr bgcolor="##fafafa" style="font-wight:bold;">
						<td>Linea</td>
						<td><cf_translate key=LB_Oficina>Oficina</cf_translate></td>
						<td><cf_translate key=LB_Documento>Documento</cf_translate></td>
						<td><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></td>
						<td><cf_translate key=LB_Ref>Ref</cf_translate></td>
						<td><cf_translate key=LB_Cuenta>Cuenta</cf_translate></td>
						<td nowrap="nowrap"><cf_translate key=LB_DescCuenta>Desc. Cuenta</cf_translate></td>
						<td nowrap="nowrap"><cf_translate key=LB_Empresa>Empresa</cf_translate></td>						
						<td nowrap="nowrap" align="right"><cf_translate key=LB_MontoOriginal>Monto Original</cf_translate></td>
						<td align="right"><cf_translate key=LB_Debitos>D&eacute;bitos</cf_translate></td>
						<td align="right"><cf_translate key=LB_Creditos>Cr&eacute;ditos</cf_translate></td>
					</tr>
				<!--- detalle de lineas de asiento de otra empresa (EMPRESA B)--->
					<cfquery name="rsReporteEncDetGen" datasource="#session.DSN#">
						select distinct d.Dlinea as Linea,d.Ddocumento as Documento,
							d.Ddescripcion as Descripcion, d.Dreferencia as Referencia,
							cf.CFformato as Cuenta, cf.CFdescripcion as DescCuenta,
							o.Oficodigo as Oficina, coalesce(d.Doriginal, 1) as  Monto,
							m.Msimbolo as Moneda, coalesce(d.Dtipocambio, 1) as	 TipoCambio, 
							case when d.Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
							case when d.Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
							m.Miso4217, (select e.Edescripcion from Empresas e where Ecodigo=cf.Ecodigo) as empresa
						from 
							<cfif rsAsientosGeneradosEnc.aplicado EQ "0">
								DContables d
							<cfelse>
								HDContables d
							</cfif>
							inner join CFinanciera cf on cf.CFcuenta = d.CFcuenta
							inner join Monedas m on m.Mcodigo = d.Mcodigo
							inner join Oficinas o on o.Ecodigo = d.Ecodigo and o.Ocodigo = d.Ocodigo
						where d.IDcontable=#rsAsientosGeneradosEnc.Idcontabledest# and d.Ecodigo=#rsAsientosGeneradosEnc.Ecodigodest#
					</cfquery>
					<cfloop query="rsReporteEncDetGen">
						<tr>
							<td>#rsReporteEncDetGen.Linea#</td>
							<td>#rsReporteEncDetGen.Oficina#</td>
							<td>#rsReporteEncDetGen.Documento#</td>
							<td>#rsReporteEncDetGen.Descripcion#</td>
							<td>#rsReporteEncDetGen.Referencia#</td>
							<td>#rsReporteEncDetGen.Cuenta#</td>
							<td nowrap="nowrap">#rsReporteEncDetGen.DescCuenta#</td>
							<td nowrap="nowrap"><span style="cursor:pointer;" alt="#rsReporteEncDetGen.empresa#" title="#rsReporteEncDetGen.empresa#" >#Left(rsReporteEncDetGen.empresa, 12)#</span></td>
							<td nowrap="nowrap" align="right">#numberformat(rsReporteEncDetGen.Monto,',_.__')#</td>
							<td align="right">#numberformat(rsReporteEncDetGen.Debitos,',_.__')#</td>
							<td align="right">#numberformat(rsReporteEncDetGen.Creditos,',_.__')#</td>
						</tr>						
					</cfloop>
					<tr><td colspan="12"> <br/><br/></td></tr>
				</cfoutput>				
				</table>
				<br/><br/>
			</td></tr>
			</cfif>
		</cfif><!--- fin if intercompany--->
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15">&nbsp;</td></tr>
		<tr><td colspan="15" align="center">----------------------------------- <cf_translate key=LB_FinCons>Fin de la Consulta</cf_translate> -----------------------------------</td></tr>
	</table>
 </form>
<script language="javascript" type="text/javascript">
	function backREG(){
		document.formsql.submit();
	}	
</script>	

<cffunction name="fnNiveles" returntype="string" output="false">
	<cfargument name="Cta">
	
	<cfset LvarCta = Arguments.Cta>
	<cfif LvarNivs LT 0>
		<cfreturn LvarCta>
	<cfelseif LvarNivs EQ 0>
		<cfreturn left(LvarCta,4)>
	</cfif>

	<cfset n = 0>
	<cfloop index="i" from="5" to="#len(LvarCta)#">
		<cfif mid(LvarCta,i,1) EQ "-">
			<cfset n=n+1>
			<cfif n GT LvarNivs>
				<cfreturn left(LvarCta,i-1)>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn LvarCta>
</cffunction>
