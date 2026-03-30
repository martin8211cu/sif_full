<cfset sbConfigurar()>
<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid, CPPfechaDesde
	  from CPresupuestoPeriodo p inner join Monedas m on p.Mcodigo=m.Mcodigo
	 where p.Ecodigo = #Session.Ecodigo#
	   and p.CPPestado <>0
	 order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>

<cfif rsPeriodos.CPPid EQ "">
	<BR>
	<div style="color:#FF0000; text-align:center">
	No existen Periodos de Presupuesto Abiertos
	</div>
	<BR>
	<cfexit>
</cfif>

<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>
<cfif IsDefined('url.tab')>
	<cfset form.tab = url.tab>
<cfelse>
	<cfparam name="form.tab" default="1">
</cfif>
<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6', form.tab) )>
	<cfset form.tab = 1 >
</cfif>

<cfswitch expression="#form.tab#">
	<cfcase value="1"><cfset LvarTipoTab='I'></cfcase>
	<cfcase value="2"><cfset LvarTipoTab='E'></cfcase>
	<cfcase value="3"><cfset LvarTipoTab='C'></cfcase>
	<cfcase value="4"><cfset LvarTipoTab='X'></cfcase>
	<cfcase value="5"><cfset LvarTipoTab='*'></cfcase>
	<cfcase value="6"><cfset LvarTipoTab='*'></cfcase>
</cfswitch>

<table>
<tr>
<td valign="top">
Per&iacute;odo&nbsp;Presupuestario:
</td>
<td>
<cf_cboCPPid session="true" createform="filtroAcciones" onChange="this.form.submit();" CPPestado="0,1">
</td>
</tr>
</table>
<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select CPPid, CPPfechaDesde
	  from CPresupuestoPeriodo p
	 where p.Ecodigo = #Session.Ecodigo#
	   and p.CPPid = #session.CPPid#
</cfquery>
<cfset Lvar2012 = rsPeriodos.CPPfechaDesde GTE createdate(2012,1,1)>

<cfquery name="rsTiposMovimientos" datasource="#Session.DSN#">
    select m.CPTMorden2, m.CPTMdescripcion as CPTMdescripcion, c.Cmayor, m.CPTMtipoMov
    	from CPtipoMov m
        left join CPtipoMovContable c
            on c.Ecodigo = #Session.Ecodigo#
            and c.CPPid = #session.CPPid#
            and c.CPCCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTipoTab#">
            and c.CPTMtipoMov = m.CPTMtipoMov
	<cfif LvarTipoTab EQ "E">
		<cfif NOT Lvar2012>
			where m.CPTMtipoMov in ('D','A','M','VC','CA','CC','E','EJ','P')
			   or m.CPTMtipoMov in ('T1','T5','T6','T7')
		<cfelse>
			where m.CPTMtipoMov in ('D','A','M','VC','RA','RC','RP','CA','CC','E','EJ','P')
			   or m.CPTMtipoMov in ('T1','T4','T5','T6','T7')
		</cfif>
	<cfelse>
		where m.CPTMtipoMov in ('D','A','M','VC','E','P')
		   or m.CPTMtipoMov in ('T1','T6','T7')
	</cfif>
     order by m.CPTMorden1, m.CPTMorden2
</cfquery>

<table width="100%" cellpadding="2" cellspacing="0" style="vertical-align:top; ">
    <tr><td valign="top">
    <form style="margin:0; " action="ParametrizaContaPres-sql.cfm" method="post" name="form1"  >
    <input type="hidden" name="tipoTab" value="<cfoutput>#LvarTipoTab#</cfoutput>">
	<input type="hidden" name="hCPPid" value="<cfoutput>#form.cppid#</cfoutput>">
    <input type="hidden" name="tab" value="<cfif isdefined('form.tab') and form.tab NEQ ''><cfoutput>#form.tab#</cfoutput><cfelse>1</cfif>">
    <cf_tabs width="100%" onclick="tab_set_current_param">

        <cf_tab text="Ingresos"		id="1" selected="#form.tab is '1'#">
            <cfinclude template="ParametrizaContaPres-ingresos.cfm">
        </cf_tab>
        <cf_tab text="Egresos"		id="2" selected="#form.tab is '2'#">
            <cfinclude template="ParametrizaContaPres-egresos.cfm">
        </cf_tab>
        <cf_tab text="Costos"		id="3" selected="#form.tab is '3'#">
            <cfinclude template="ParametrizaContaPres-costos.cfm">
        </cf_tab>
		<cf_tab text="Cierre"	id="5" selected="#form.tab is '5'#">
			<cf_web_portlet_start border="true" titulo="Cuentas de Superavit o Deficit Financiero para Cierre Contabilidad Presupuestal" >
				<cfquery name="rsSuperavit" datasource="#session.dsn#">
					select Pvalor as CFcuenta, 0 as Ccuenta
					  from Parametros
					 where Ecodigo = #session.Ecodigo#
					   and Pcodigo = 1141
				</cfquery>
				<cfquery name="rsDeficit" datasource="#session.dsn#">
					select Pvalor as CFcuenta, 0 as Ccuenta
					  from Parametros
					 where Ecodigo = #session.Ecodigo#
					   and Pcodigo = 1142
				</cfquery>
				<cfquery name="rsADEFAS" datasource="#session.dsn#">
					select Pvalor as CFcuenta, 0 as Ccuenta
					  from Parametros
					 where Ecodigo = #session.Ecodigo#
					   and Pcodigo = 1143
				</cfquery>
				<table>
					<tr>
						<td>
							Cuenta de Superávit Financiero:
						</td>
						<td>
							<cf_cuentas Ccuenta="Csuperavit" CFcuenta="CFsuperavit" query="#rsSuperavit#">
						</td>
					</tr>
					<tr>
						<td>
							Cuenta de Déficit Financiero:
						</td>
						<td>
							<cf_cuentas Ccuenta="Cdeficit" CFcuenta="CFdeficit" query="#rsDeficit#">
						</td>
					</tr>
                   <!--- SML.  Inicio Modificacion para activar la cuenta de Adeudos Periodos Anteriores--->
                   <tr>
						<td>
							Cuenta de Adeudos Periodos Anteriores:
						</td>
						<cfquery name="rsSQLP" datasource="#session.dsn#">
							select Pvalor
							  from Parametros
							 where Ecodigo = #session.Ecodigo#
							   and Pcodigo = 1143
						</cfquery>
						<td>
							<input type="checkbox" value="" id="chkCadefas" name="chkCadefas" <cfif rsSQLP.RecordCount GT 0 and rsSQLP.Pvalor neq ''>checked</cfif> onclick="fnCadefas();"/>
						</td>
					</tr>
					<tr id="trCadefas" <cfif rsSQLP.RecordCount eq 0 or rsSQLP.Pvalor eq ''> style="display:none"</cfif>>
						<td>

						</td>
						<td>
							<cf_cuentas Ccuenta="Cadefas" CFcuenta="CFadefas" query="#rsADEFAS#">
						</td>
					</tr>
                    <!--- SML. Final Modificacion para activar la cuenta de Adeudos Periodos Anteriores--->
					<tr>
						<td>

						</td>
						<td>
							<input type="submit" value="Guardar" name="btnParam" />
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</cf_tab>
		<!--- ERBG Parametrizar Cuentas de Compromido Automatico INICIA --->
		<!--- MSEG Parametrizar Cuentas de Compromido Automatico por periodos INICIA --->
		<cf_tab text="Generar Compromiso Automático Mensual"	id="6" selected="#form.tab is '6'#">
           <cfquery name="rsComprAut" datasource="#session.dsn#">
                select CPCompromiso
				from CPparametros
				where Ecodigo = #session.Ecodigo#
				       and CPPid = #Form.CPPid#
            </cfquery>
        	<table>
            	<tr>
                   	<td align="right" nowrap><strong>No Generar Compromisos Automáticos</strong>

                    <input type="checkbox" value="" name="chkNoCP" <cfif rsComprAut.recordCount GT 0 and rsComprAut.CPCompromiso eq 'True'> checked </cfif>>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td align="center">
                        <input type="submit" value="Guardar" name="btnParam" />
                    </td>
                </tr>
        	</table>
        </cf_tab>
       <!--- ERBG Parametrizar Cuentas de Compromido Automatico FIN --->
    </cf_tabs>
    </form>
    </td></tr>

</table>

<script language="javascript1.2" type="text/javascript">

	function tab_set_current_param (n){
		location.href='ParametrizaContaPres.cfm?tab='+escape(n);
	}

	function fnCadefas(){

		var f1 = document.form1;

		if(document.form1.chkCadefas.checked == true){
			document.getElementById("trCadefas").style.display = "";

		}
		if(document.form1.chkCadefas.checked == false){
			document.getElementById("trCadefas").style.display = "none";
		}
		return true;
	}

</script>

<cffunction name="sbConfigurar">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select count(1) as cantidad from CPtipoMov
	</cfquery>

	<cfif rsSQL.cantidad eq 22>
		<cfreturn>
	</cfif>

	<cfquery datasource="#Session.DSN#">
		delete from CPtipoMov
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (0, 1, 'D',  'DISPONIBLE POR EJERCER')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (1, 0, 'T1', 'MOMENTOS DE AUTORIZACION PRESUPUESTARIA')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (1, 1, 'A',  'Aprobación de Presupuesto Ordinario')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (1, 2, 'M',  'Modificación de Presupuesto Extraordinario')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (1, 3, 'VC', 'Variación Cambiaria')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (2, 0, 'T2', 'MOVIMIENTOS DE AUTORIZACION PLANEADOS')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (2, 1, 'T',  'Traslados de Presupuesto')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (2, 2, 'TE', 'Traslados con Autorización Especial')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (3, 0, 'T3', 'MOVIMIENTOS DE AUTORIZACION NO PLANEADOS')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (3, 1, 'ME', 'Modificación por Excesos Autorizados')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (4, 0, 'T4', 'MOMENTOS DE RESERVA PRESUPUESTARIA')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (4, 1, 'RA', 'Presupuesto Reservado Períodos Anteriores')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (4, 2, 'RC', 'Presupuesto Reservado')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (4, 3, 'RP', 'Provisiones Presupuestarias')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (5, 0, 'T5', 'MOMENTOS DE COMPROMISO PRESUPUESTARIO')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (5, 1, 'CA', 'Presupuesto Comprometido Períodos Anteriores')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (5, 2, 'CC', 'Presupuesto Comprometido')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (6, 0, 'T6', 'MOMENTOS DE DEVENGADO PRESUPUESTARIO')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (6, 1, 'E',  'Presupuesto Ejecutado')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (7, 0, 'T7', 'MOMENTOS DE FLUJO DE EFECTIVO')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (7, 1, 'EJ', 'Presupuesto Ejercido')
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		insert into CPtipoMov (CPTMorden1, CPTMorden2, CPTMtipoMov, CPTMdescripcion) values (7, 2, 'P',  'Presupuesto Pagado')
	</cfquery>
</cffunction>
