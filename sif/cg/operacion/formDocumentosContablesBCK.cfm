<!--- 
	Modificado por: Ana Villavicencio 
	Fecha: 17 de Agosto del 2005
	Motivo: Correccion de error.  No se permite el registro de documentos retroactivos para el periodo actual.
			Y permite el registro de documentos de meses mayores al mes actual. 
			Se modificó la forma de llenar el combo de meses para el documento, 
			se asigna un valor de mes fiscal al mes calendario, asi muestra los meses de acuerdo al año fiscal
			(inicio octubre, fin setiembre).
			
	Modificado por: Josue Gamboa
	Fecha: 5 setiembre del 2005
	Motivo: Se quito lo del mes fiscal, la contabilidad debe trabajar con meses normales.
			El funcionamiento es como sigue: 
				i.  para asientos normales, los meses deben ser mayores o igual al mes actual de la conta
				ii. para asientos retroactivos, los meses deben ser menores al mes actual.
 --->

<!--- MODOS Y Llaves para Encabezado y Detalle --->
<cfset modo = "ALTA">
<cfset mododet = "ALTA">
<cfif isdefined("IDcontable") and len(trim(IDcontable)) and not isdefined("form.btnNuevo")>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined("Form.Dlinea") and len(trim(Form.Dlinea))>
	<cfset Dlinea = form.Dlinea>
	<cfset mododet = "CAMBIO">
<cfelse>
	<cfset Dlinea = -1>
</cfif>
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ecodigo,Ocodigo,Odescripcion 
	from Oficinas 
	<cfif inter eq "S">
		where
		Ecodigo in ( select  Ecodigo
			  from Empresas
			 where cliente_empresarial =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">)
	<cfelse>
		where
		Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfif>
	order by Ecodigo,Ocodigo 
</cfquery>
<!--- Variables para etiquetas de Traduccin --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaBalOri = t.Translate('PolizaBalOri','Balance de P&oacute;liza en Moneda Origen')>
<cfset PolizaBalLoc = t.Translate('PolizaBalLoc','Balance de P&oacute;liza en Moneda Local')>
<cfset msgAplicar = t.Translate('PolizaAplicar','No tiene permisos para aplicar la p&oacute;liza')>

<!--- Codigo para Aplicacin de Asientos --->
<cfset ListaAplicar = "">
<cfif isDefined("Form.Aplicar") and Len(Trim(IDcontable)) NEQ 0>
	<cfset ListaAplicar = IDcontable>
</cfif>
<cfif isDefined("Form.btnAplicar") and isdefined("Form.chk") and Len(trim(Form.chk))>
	<cfset ListaAplicar = Form.chk>	
</cfif>
<cfset request.error.backs = 2>
<cfif len(trim(ListaAplicar))>
	<cfloop list="#ListaAplicar#" index="IDcontable">
		<!--- Verificar el permiso antes de aplicar el asiento --->
		<cfquery name="chkPermiso" datasource="#Session.DSN#">
			select 1
			from EContables a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			and ( not exists ( 
					select 1 from UsuarioConceptoContableE b 
					where a.Cconcepto = b.Cconcepto
					and a.Ecodigo = b.Ecodigo
				) or exists (
					select 1
					from ConceptoContableE b, UsuarioConceptoContableE c
					where a.Cconcepto = b.Cconcepto
					and a.Ecodigo = b.Ecodigo
					and b.Cconcepto = c.Cconcepto
					and b.Ecodigo = c.Ecodigo
					and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
					and c.UCCpermiso in (4,5,6,7)
				)
			)
		</cfquery>
	
		<!--- Si tiene permisos entonces puede aplicar el asiento --->
		<cfif chkPermiso.recordCount GT 0>
			<cftransaction>
				<!--- Movimientos Previos antes de la Aplicación de un Asiento Intercompany --->
				<cfif inter eq "S">
					<cfinvoke 
					 component="sif.Componentes.CG_AplicaIntercompany"
					 method="CG_AplicaIntercompany">
						 <cfinvokeargument name="IDcontable" value="#IDcontable#">
					</cfinvoke>
				</cfif>

				<!--- Aplicación del Asiento --->
				<cfinvoke 
				 component="sif.Componentes.CG_AplicaAsiento"
				 method="CG_AplicaAsiento">
					 <cfinvokeargument name="IDcontable" value="#IDcontable#">
					 <cfinvokeargument name="CtlTransaccion" value="false">
				</cfinvoke>
			</cftransaction>
		<cfelse>
			<cfthrow message="#msgAplicar#">
		</cfif>
	</cfloop>
	<cflocation addtoken="no" url="listaDocumentosContables#sufix#.cfm">
</cfif>

<!--- rs con el codigo de la cuenta contable de balance de asientos --->
<cfquery name="rsParamCuentaBalance" datasource="#Session.DSN#">
	Select Pvalor as CFcuenta, '' as Ccuenta
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo=25
</cfquery>
<cfif Len(Trim(rsParamCuentaBalance.CFcuenta)) EQ 0>
	<cf_errorCode	code = "50241" msg = "No se ha definido la cuenta de Balance de Asientos en parametros">
</cfif>
<cfif Len(Trim(rsParamCuentaBalance.CFcuenta))>
	<cfquery name="rsParamCuentaBalance" datasource="#Session.DSN#">
		Select '#rsParamCuentaBalance.CFcuenta#' as CFcuenta, Ccuenta
		from CFinanciera c
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CFcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamCuentaBalance.CFcuenta#">
	</cfquery>
</cfif>

<cfset poneBtnBalancear = false>
<cfif modo neq "ALTA">
	<!--- Si es intercompany solo se valida por Moneda y no por oficina --->
	<cfif inter EQ 'S'>
		<cfquery name="rsBalanceO" datasource="#Session.DSN#">
			select distinct
				b.Mnombre,
				b.Msimbolo, 
				sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
				sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos,
				sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
				sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL
			from DContables a
				inner join Monedas b on a.Ecodigo = b.Ecodigo and
				a.Mcodigo = b.Mcodigo 
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			group by b.Mnombre, b.Msimbolo
		</cfquery>
	<cfelse>
		<cfquery name="rsBalanceO" datasource="#Session.DSN#">
			select distinct
				b.Mnombre,
				b.Msimbolo, 
				c.Odescripcion, 
				sum(case when a.Dmovimiento = 'D' then a.Doriginal else 0.00 end) as Debitos,
				sum(case when a.Dmovimiento = 'C' then a.Doriginal else 0.00 end) as Creditos,
				sum(case when a.Dmovimiento = 'D' then a.Dlocal else 0.00 end) as DebitosL,
				sum(case when a.Dmovimiento = 'C' then a.Dlocal else 0.00 end) as CreditosL
			from DContables a
				inner join Monedas b on a.Ecodigo = b.Ecodigo and
				a.Mcodigo = b.Mcodigo 
				inner join 
				Oficinas c on 
				a.Ecodigo = c.Ecodigo
				and a.Ocodigo = c.Ocodigo
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			group by b.Mnombre, b.Msimbolo, c.Odescripcion
		</cfquery>
	</cfif>
	<!--- Ciclo para averiguar si se coloca o no el boton de Balancear Asiento --->	
	<cfset varDif = 0>	
	<!--- No se pone el botón de balanceo cuando se están registrando documentos intercompañía --->
	<cfif inter EQ 'N' and isdefined('rsBalanceO') and rsBalanceO.recordCount GT 0>
		<cfloop query="rsBalanceO">
			<cfset varDif = rsBalanceO.DebitosL - rsBalanceO.CreditosL>
			<cfif varDif NEQ 0>
				<cfset poneBtnBalancear = true>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
		select  a.Cconcepto, Cdescripcion
		from ConceptoContableE a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and   not exists ( select 1 from UsuarioConceptoContableE b 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and   a.Cconcepto = b.Cconcepto
		and   a.Ecodigo = b.Ecodigo
		)  
		UNION
		select a.Cconcepto, Cdescripcion 
		from ConceptoContableE a,UsuarioConceptoContableE   b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and   a.Cconcepto = b.Cconcepto
		and   a.Ecodigo = b.Ecodigo
		and  Usucodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">	
</cfquery>
<cfquery name="rsPrePeriodo" datasource="#Session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 30
	and Mcodigo = 'CG'	  
</cfquery>

<cfif isdefined("paramretro") and paramretro eq 2>

	<cfset rsPeriodo = QueryNew("Pvalor")>
	<cfset temp = QueryAddRow(rsPeriodo,3)>
	<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,1)>
	<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo-1,2)>
	<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo-2,3)>

<cfelse>

	<cfset rsPeriodo = QueryNew("Pvalor")>
	<cfset temp = QueryAddRow(rsPeriodo,3)>
	<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,1)>
	<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+1,2)>
	<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+2,3)>

</cfif>

<cfquery name="rsPeriodoActual" datasource="#Session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 30
	and Mcodigo = 'CG'	  
</cfquery>
<cfset periodoActual = rsPeriodoActual.Pvalor>
<cfquery name="rsMes" datasource="#Session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 40
	and Mcodigo = 'CG'
</cfquery>
<cfset mesActual = rsMes.Pvalor>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as mes, b.VSdesc as descripcion,
		case when VSvalor = '1' then 4
			when VSvalor = '2' then 5 
			when VSvalor = '3' then 6
			when VSvalor = '4' then 7
			when VSvalor = '5' then 8
			when VSvalor = '6' then 9
			when VSvalor = '7' then 10
			when VSvalor = '8' then 11
			when VSvalor = '9' then 12
			when VSvalor = '10' then 1
			when VSvalor = '11' then 2 else 3 end as mesFiscal
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">, descripcion
</cfquery>

<cfset meses = ValueList(rsMeses.descripcion,',')>
<cfset rsDebCred = QueryNew("tipo,descripcion")>
<cfset QueryAddRow(rsDebCred,2)>
<cfset QuerySetCell(rsDebCred,"tipo","D",1)>
<cfset QuerySetCell(rsDebCred,"descripcion","Débito",1)>
<cfset QuerySetCell(rsDebCred,"tipo","C",2)>
<cfset QuerySetCell(rsDebCred,"descripcion","Crédito",2)>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select IDcontable, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Efecha, Edescripcion, 
		Edocbase, Ereferencia, ECauxiliar, ECusuario, ECselect, ECreversible, ECestado, ECtipo, ts_rversion
		from EContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
	</cfquery>
	<cfquery name="rsTieneLineas" datasource="#Session.DSN#">
		select 1 
		from DContables a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
	</cfquery>
	<cfquery name="TCsug" datasource="#Session.DSN#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and tc.Hfecha = (
		select max(Hfecha)
		from Htipocambio tc1 
		where tc1.Ecodigo = tc.Ecodigo 
		and tc1.Mcodigo = tc.Mcodigo
		and tc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.Efecha#">
		)
	</cfquery>
	
	<cfif mododet NEQ "ALTA">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select b.CFformato, b.CFdescripcion, c.Cformato, c.Cdescripcion,
			IDcontable, Dlinea, a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, a.Edocumento, a.Ocodigo, a.Ddescripcion, 
			a.Ddocumento, a.Dreferencia, a.Dmovimiento, a.Ccuenta, a.CFcuenta, a.Doriginal, a.Dlocal, a.Mcodigo, a.Dtipocambio, a.ts_rversion
			from DContables a
				inner JOIN CFinanciera b
					inner JOIN CContables c 
						ON c.Ccuenta = b.Ccuenta
					ON a.CFcuenta = b.CFcuenta
				
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Dlinea#">
			and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		</cfquery>
	</cfif>
</cfif>

<!--- Averiguar si se tiene permisos para ver, modificar o aplicar el asiento contable --->
<!--- 
	El campo UCCpermiso funciona de la siguiente manera tomando los bits de derecha a izquierda
	bit 1: Visualizacin / Impresin
	bit 2: Modificacin
	bit 3: Aplicacin
--->
<cfset PermisoVisualizar = true>
<cfset PermisoModificar = true>
<cfset PermisoAplicar = true>
<cfif modo EQ "CAMBIO">
	<cfquery name="chkPermiso" datasource="#Session.DSN#">
		select 1
		from EContables a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		and ( not exists ( 
				select 1 from UsuarioConceptoContableE b 
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
			) or exists (
				select 1
				from ConceptoContableE b, UsuarioConceptoContableE c
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
				and b.Cconcepto = c.Cconcepto
				and b.Ecodigo = c.Ecodigo
				and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
				and c.UCCpermiso in (1,3,5,7)
			)
		)
	</cfquery>
	<cfif chkPermiso.recordCount EQ 0>
		<cfset PermisoVisualizar = false>
	</cfif>

	<cfquery name="chkPermiso" datasource="#Session.DSN#">
		select 1
		from EContables a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		and ( not exists ( 
				select 1 from UsuarioConceptoContableE b 
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
			) or exists (
				select 1
				from ConceptoContableE b, UsuarioConceptoContableE c
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
				and b.Cconcepto = c.Cconcepto
				and b.Ecodigo = c.Ecodigo
				and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
				and c.UCCpermiso in (2,3,6,7)
			)
		)
	</cfquery>
	<cfif chkPermiso.recordCount EQ 0>
		<cfset PermisoModificar = false>
	</cfif>

	<cfquery name="chkPermiso" datasource="#Session.DSN#">
		select 1
		from EContables a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		and ( not exists ( 
				select 1 from UsuarioConceptoContableE b 
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
			) or exists (
				select 1
				from ConceptoContableE b, UsuarioConceptoContableE c
				where a.Cconcepto = b.Cconcepto
				and a.Ecodigo = b.Ecodigo
				and b.Cconcepto = c.Cconcepto
				and b.Ecodigo = c.Ecodigo
				and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
				and c.UCCpermiso in (4,5,6,7)
			)
		)
	</cfquery>
	<cfif chkPermiso.recordCount EQ 0>
		<cfset PermisoAplicar = false>
	</cfif>
</cfif>

<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<script language="JavaScript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//funciones
	function GetmesFiscal(mes){
		if (mes == 1) return 4;
		if (mes == 2) return 5;
		if (mes == 3) return 6;
		if (mes == 4) return 7;
		if (mes == 5) return 8;
		if (mes == 6) return 9;
		if (mes == 7) return 10;
		if (mes == 8) return 11;
		if (mes == 9) return 12;
		if (mes == 10) return 1;
		if (mes == 11) return 2;
		if (mes == 12) return 3;
	}

	function AgregarCombo(combo,codigo) {
		var cont = 0;
		var periodo = <cfoutput>#periodoActual#</cfoutput>;

		<cfif isdefined("url.paramretro") and  url.paramretro eq 2 >
			var mes = 13;
			if ( parseInt(document.form1.Eperiodo.value) == parseInt(periodo) ){
				mes = codigo;
			}
	
			combo.length=0;
			<cfoutput query="rsMeses">
				if ( parseInt(#Trim(rsMeses.mes)#) < parseInt(mes) ) {
					combo.length=cont+1;
					combo.options[cont].value='#rsMeses.mes#';
					combo.options[cont].text='#rsMeses.descripcion#';
				<cfif modo NEQ "ALTA" and #rsMeses.mes# EQ #rsDocumento.Emes#>
					combo.options[cont].selected=true;
				</cfif>
					cont++;
				};
			</cfoutput>
		<cfelse>
			var mes = 1;
			if ( parseInt(document.form1.Eperiodo.value) == parseInt(periodo) ){
				mes = codigo;
			}
	
			combo.length=0;
			<cfoutput query="rsMeses">
				if ( parseInt(#Trim(rsMeses.mes)#) >= parseInt(mes) ) {
					combo.length=cont+1;
					combo.options[cont].value='#rsMeses.mes#';
					combo.options[cont].text='#rsMeses.descripcion#';
				<cfif modo NEQ "ALTA" and #rsMeses.mes# EQ #rsDocumento.Emes#>
					combo.options[cont].selected=true;
				</cfif>
					cont++;
				};
			</cfoutput>
		</cfif>
	}	
	
	function AsignarHiddensEncab() {		
		document.form1._Cconcepto.value = document.form1.Cconcepto.value;		
		document.form1._Eperiodo.value = document.form1.Eperiodo.value;
		document.form1._Emes.value = document.form1.Emes.value;
		document.form1.Edocumento.disabled = false;		
		document.form1._Edocumento.value = document.form1.Edocumento.value;
		document.form1.Edocumento.disabled = true;		
		document.form1._Edescripcion.value = document.form1.Edescripcion.value;
		document.form1._Efecha.value = document.form1.Efecha.value;
		document.form1._Ereferencia.value = document.form1.Ereferencia.value;
		document.form1._Edocbase.value = document.form1.Edocbase.value;
		
			<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
				<cfif isdefined("form.ECreversible")>
				document.form1._ECreversible.value = '1';
				<cfelse>
				document.form1._ECreversible.value = '0';
				</cfif>
			</cfif>
	}

	function AsignarHiddensDet() {
		document.form1._Ccuenta.value = document.form1.Ccuenta.value;
		document.form1._CFcuenta.value = document.form1.CFcuenta.value;
		document.form1._Dmovimiento.value = document.form1.Dmovimiento.value;
		document.form1._Ocodigo.value = document.form1.Ocodigo.value;
		document.form1._Ddescripcion.value = document.form1.Ddescripcion.value;
		document.form1._Mcodigo.value = document.form1.Mcodigo.value;
		document.form1.Dtipocambio.disabled = false;
		document.form1._Dtipocambio.value = document.form1.Dtipocambio.value;
		document.form1._Doriginal.value = document.form1.Doriginal.value;
		document.form1._Dlocal.value = document.form1.Dlocal.value;		
	}	

	function Lista() {
		<cfif isdefined("paramretro")>
			location.href="listaDocumentosContables<cfoutput>#sufix#</cfoutput>.cfm";
		<cfelse>
			location.href="listaDocumentosContables<cfoutput>#sufix#</cfoutput>.cfm?inter="+document.form1.inter.value;		
		</cfif>
	}

	<!---
		Esta funcion se invoca para deshabilitar los campos modificables cuando el asiento proviene de un auxiliar
		o cuando el usuario no tiene permiso de modificacin de ese tipo de asiento
	--->
	function Deshabilitar() {
		<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)>
			// campos visibles del encabezado
			document.form1.Cconcepto.disabled = true;		
			//document.form1.Eperiodo.disabled = true;
			//document.form1.Emes.disabled = true;
			document.form1.Edocumento.disabled = true;
			document.form1.Edocumento.disabled = true;		
			document.form1.Edescripcion.disabled = true;
			document.form1.Efecha.disabled = true;
			document.form1.CalendarEfecha.disabled = true;
			document.form1.Ereferencia.disabled = true;
			document.form1.Edocbase.disabled = true;
			// campos visibles del detalle
			document.form1.Cdescripcion.disabled = true;
			document.form1.imagen.disabled = true;			
			document.form1.Dmovimiento.disabled = true;
			document.form1.Ocodigo.disabled = true;
			document.form1.Ddescripcion.disabled = true;
			document.form1.Mcodigo.disabled = true;
			document.form1.Dtipocambio.disabled = true;
			document.form1.Doriginal.disabled = true;
			document.form1.Dlocal.disabled = true;
			document.form1.Cformato.disabled = true;
			document.form1.Cmayor.disabled = true;
			document.form1.Ddocumento.disabled = true;
		</cfif>
	}
	
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function funcArchivo(pOpcion){
		var param = document.form1.IDcontable.value;
		
		if (pOpcion == 1){//La opcion 1 es para MODIFICAR documentos
			document.form1.action = 'ObjetosDocumentos<cfoutput>#sufix#</cfoutput>.cfm'/*?IDcontable='+param;*/
			document.form1.submit();
		}
		else{ //La opcion 2 es para VER documentos
			popUpWindow('../consultas/ObjetosDocumentosCons.cfm?IDcontable='+param,200,100,700,500);
			//document.form1.action = '../consultas/ObjetosDocumentosCons.cfm'
			//document.form1.submit();
		}
	}
	//-->
</script>

<style type="text/css" >
	.tituloBalance{ 
		color:#006699; 
		background-color:#F4F4F4;
		font-weight:bold;
	}
	.detalleBalance{
		color:#FFFFFF; 
		background-color:#006699;
	}
	.auxiliar{ 
		font-size:smaller;
		color:#FF0033;
		font-weight:bold;
	}

</style>
	
<form action="SQLDocumentosContables<cfoutput>#sufix#</cfoutput>.cfm" method="post" name="form1" onSubmit="javascript: _finalizar();">
	<table width="100%" border="0">
		<tr> 
			<td width="100%">
				<table width="100%" border="0">
					<!--- Lista de Balance por Monedas --->
					<tr> 
						<cfif inter eq "N">
							<td width="1%" rowspan="5" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr > 
										<td colspan="5" class="tituloBalance" align="center" nowrap>
										
											<cfoutput>#PolizaBalOri#</cfoutput>
											
										</td>
									</tr>
									<tr> 
										<td class="detalleBalance" nowrap><cf_translate key="monto">Mon</cf_translate>.&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="oficina">Oficina</cf_translate>&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="debito">D&eacute;bitos</cf_translate></td>
										<td class="detalleBalance" nowrap>&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="credito">Cr&eacute;ditos</cf_translate></td>
									</tr>
									<cfif isdefined("rsBalanceO")>
										<cfoutput query="rsBalanceO"> 
											<tr> 
												<td><font color="##0033CC">#rsBalanceO.Msimbolo#</font></td>
												<td>#rsBalanceO.Odescripcion#</td>
												<td align="right">#lscurrencyformat(rsBalanceO.Debitos,'none')#</td>
												<td>&nbsp;</td>
												<td align="right">#LSCurrencyFormat(rsBalanceO.Creditos,'none')#</td>
											</tr>
										</cfoutput> 
									</cfif>
								</table>
								<br>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr> 
										<td colspan="5" class="tituloBalance" nowrap align="center" >
										<cfoutput>#PolizaBalLoc#</cfoutput>
										</td>
									</tr>
									<tr> 
										<td class="detalleBalance" nowrap><cf_translate key="monto">Mon</cf_translate>.&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="oficina">Oficina</cf_translate>&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="debito">D&eacute;bitos</cf_translate></td>
										<td class="detalleBalance" nowrap>&nbsp;</td>
										<td class="detalleBalance" nowrap><cf_translate key="credito">Cr&eacute;ditos</cf_translate></td>
									</tr>
									<cfif isdefined("rsBalanceO")>
										<cfoutput query="rsBalanceO"> 
											<tr> 
												<td><font color="##0033CC">#rsBalanceO.Msimbolo#</font></td>
												<td>#rsBalanceO.Odescripcion#</td>
												<td align="right">#lscurrencyformat(rsBalanceO.DebitosL,'none')#</td>
												<td>&nbsp;</td>
												<td align="right">#LSCurrencyFormat(rsBalanceO.CreditosL,'none')#</td>
											</tr>
										</cfoutput> 
									</cfif>
								</table>
							</td>
						</cfif>
						<td colspan="8" class="tituloAlterno" align="center"><cf_translate key="titulodoc">Documento Contable</cf_translate></td>
					</tr>
					<!--- Mantenimiento del Encabezado --->
					<tr> 
						<td nowrap align="right"><cf_translate key="concepto">Concepto</cf_translate>:&nbsp;</td>
						<td>
							<select  name="Cconcepto" <cfif modo NEQ "ALTA">disabled</cfif> >
								<cfoutput query="rsConceptos"> 
									<option  value="#rsConceptos.Cconcepto#" <cfif modo NEQ "ALTA" and rsConceptos.Cconcepto EQ rsDocumento.Cconcepto>selected</cfif>>#rsConceptos.Cdescripcion#</option>
								</cfoutput>
							</select>
						</td>
						<td nowrap align="right"><cf_translate key="periodo">Per&iacute;odo</cf_translate>:&nbsp;</td>
						<td>
							
							<cfif modo EQ "ALTA">
								<select name="Eperiodo" 
									onChange="javascript:if (document.form1.Eperiodo.value == '<cfoutput>#periodoActual#</cfoutput>') AgregarCombo(document.form1.Emes,'<cfoutput>#mesActual#</cfoutput>'); else AgregarCombo(document.form1.Emes,'9');"<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)> disabled</cfif> >
									<cfoutput query="rsPeriodo"> 
										<option value="#rsPeriodo.Pvalor#" <cfif modo NEQ "ALTA" and rsPeriodo.Pvalor EQ rsDocumento.Eperiodo>selected</cfif>>#rsPeriodo.Pvalor#</option>
									</cfoutput>
								</select>
							<cfelse>
								<cfoutput>
									#rsDocumento.Eperiodo#
									<input type="hidden" name="Eperiodo" value="#rsDocumento.Eperiodo#">
								</cfoutput>
							</cfif>
							
						</td>
						<td nowrap align="right"><cf_translate key="mes">Mes</cf_translate>:&nbsp;</td>
						<td>
							<!---<select name="Emes" <cfif modo NEQ "ALTA">disabled</cfif>>--->
							<cfif modo EQ "ALTA">
								<select name="Emes"<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)> disabled</cfif> ></select><script language="JavaScript">if (document.form1.Eperiodo.value == '<cfoutput>#periodoActual#</cfoutput>') AgregarCombo(document.form1.Emes,'<cfoutput>#mesActual#</cfoutput>'); else AgregarCombo(document.form1.Emes,'1');</script>
							<cfelse>
								<cfoutput>
									<cfif ListLen(meses, ',') NEQ 0>
										#Trim(ListGetAt(meses,rsDocumento.Emes, ','))#
									</cfif>
									<input type="hidden" name="Emes" value="#rsDocumento.Emes#">
								</cfoutput>
							</cfif>
						</td>
						
						<cfif isdefined("paramretro")>
							<td align="right">
								<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
									<input name="paramretro" type="checkbox" id="paramretro" disabled value="2" checked>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
									Retroactivo
								<cfelse>
									&nbsp;
								</cfif>
							</td>						
						<cfelse>
							<td align="right">
								<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
									<input name="ECreversible" type="checkbox" id="ECreversible" value="1"<cfif modo EQ 'CAMBIO' and rsDocumento.ECreversible EQ 1> checked</cfif>>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
									<cf_translate key="reversible">Reversible</cf_translate>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</cfif>
					</tr>
					<tr> 
						<td nowrap align="right">
							<cfoutput>#PolizaE#</cfoutput>:&nbsp;
						</td>
						<td>
							<input name="Edocumento" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edocumento#</cfoutput></cfif>" size="15" maxlength="15" disabled>
						</td>
						<td nowrap align="right"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate>:&nbsp;</td>
						<td colspan="5">
							<input name="Edescripcion" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edescripcion#</cfoutput></cfif>" size="63" maxlength="100" onFocus="javascript:this.select();"> 
							<script language="JavaScript">document.form1.Edescripcion.focus();</script> 
						</td>
					</tr>
					<tr> 
						<td nowrap align="right"><cf_translate key="fecha">Fecha</cf_translate>:&nbsp;</td>
						<td>
							<cfif modo NEQ 'ALTA'> 
								<cf_sifcalendario name="Efecha" value="#LSDateFormat(rsDocumento.Efecha,'dd/mm/yyyy')#">
							<cfelse>
								<cf_sifcalendario name="Efecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">			  			  
							</cfif>
						</td>
						<td nowrap align="right"><cf_translate key="referencia">Referencia</cf_translate>:&nbsp;</td>
						<td colspan="3">
							<input name="Ereferencia" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Ereferencia#</cfoutput></cfif>" size="25" maxlength="25" onFocus="javascript:this.select();">
						</td>
						<td nowrap align="right"><cf_translate key="documento">Documento</cf_translate>:&nbsp;</td>
						<td>
							<input name="Edocbase" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.Edocbase#</cfoutput></cfif>" size="20" maxlength="20" onFocus="javascript:this.select();">
						</td>
					</tr>
					<tr> 
						<td colspan="8">
							<input type="hidden" name="_Cconcepto"> <input type="hidden" name="_Eperiodo"> 
							<input type="hidden" name="_Emes"> <input type="hidden" name="_Edocumento"> 
							<input type="hidden" name="_Edescripcion"> <input type="hidden" name="_Efecha"> 
							<input type="hidden" name="_Ereferencia"> <input type="hidden" name="_Edocbase">
							<cfif modo EQ "ALTA" or (modo EQ "CAMBIO" and rsDocumento.ECauxiliar EQ 'N')>
								<input type="hidden" name="_ECreversible"> 
							</cfif>
							<cfset tsE = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDocumento.ts_rversion#" returnvariable="tsE"></cfinvoke>
							</cfif>
							<input type="hidden" name="IDcontable" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.IDcontable#</cfoutput></cfif>"> 
							<input type="hidden" name="ECauxiliar" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.ECauxiliar#</cfoutput><cfelse>N</cfif>"> 
							<input type="hidden" name="ECusuario" value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.ECusuario#</cfoutput></cfif>"> 
							<input type="hidden" name="ECselect" value="0"> <input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>"> 
						</td>
					</tr>
				</table>
				<script language="JavaScript">AsignarHiddensEncab();</script>
			</td>
		</tr>
		<cfif isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S" and modo NEQ "ALTA">
		<tr>
			<td colspan="7" align="center" class="auxiliar">
				<cf_translate key="documento_auxiliar">Documento Generado desde un Sistema Auxiliar. No se puede modificar.</cf_translate>
			</td>
		</tr>
		<tr>
			<td>&nbsp;
				
			</td>
		</tr>
		</cfif>
		<!---------------------------------------------------------------------------------->
		<!--- Detalle del Documento--->
		<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
			<tr> 
				<td>
					<table width="100%" border="0"
					<cfif modo EQ "CAMBIO" and ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)>
					style="display:none"
					</cfif>
					>
						<tr>
							<td style="border-top:1px solid #666666; font-size:12px; color:#666666;" colspan="7" align="center"><strong>L&iacute;nea de Detalle</strong></td>
						</tr>
						<tr> 
							<td width="22%">&nbsp;</td>
							<td nowrap align="right"><cf_translate key="cuenta_contable">Cuenta Financiera</cf_translate>:</td>
							<td width="342">
								<cfif inter eq "S">
									<cfif modoDet NEQ "ALTA">
										<cf_cuentas  Intercompany='yes'  conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="C" movimiento="S" frame="frame1" descwidth="50" onchange="document.getElementById('trCcuenta').style.display='none';" onchangeIntercompany="CambiarOficina(this);">
									<cfelse>
										<cf_cuentas   Intercompany='yes'  conexion="#Session.DSN#" conlis="S" auxiliares="C" movimiento="S" frame="frame1" descwidth="50" onchange=""  onchangeIntercompany="CambiarOficina(this);">
									</cfif>
								<cfelse>
									<cfif modoDet NEQ "ALTA">
										<cf_cuentas  conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="C" movimiento="S" frame="frame1" descwidth="50" onchange="document.getElementById('trCcuenta').style.display='none';">
									<cfelse>
										<cf_cuentas  conexion="#Session.DSN#" conlis="S" auxiliares="C" movimiento="S" frame="frame1" descwidth="50" onchange="">
									</cfif>
								</cfif>	
							</td>
							<td nowrap align="right"><cf_translate key="movimiento">Movimiento</cf_translate>:&nbsp;</td>
							<td width="253">
								<select name="Dmovimiento">
									<cfoutput query="rsDebCred"> 
										<option value="#rsDebCred.tipo#" <cfif modoDet NEQ "ALTA" and "#rsDebCred.tipo#" EQ "#rsLinea.Dmovimiento#">selected</cfif>>#rsDebCred.descripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr id="trCcuenta">
						<cfif modoDet NEQ "ALTA" AND rsLinea.Cformato NEQ rsLinea.CFformato>
							<td width="22%">&nbsp;</td>
							<td nowrap align="right"><cf_translate key="cuenta_contable">Cuenta Contable</cf_translate>:</td>
							<td colspan="3">
							<cfoutput>
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td nowrap>
											<input maxlength="4" size="4"  type="text" disabled tabindex="-1"
												value="#mid(rsLinea.Cformato,1,4)#">
										</td>
										<td nowrap> 
											<input maxlength="27" size="32" type="text" disabled tabindex="-1"
											value="#mid(rsLinea.Cformato,6,100)#">
										</td>
										<td nowrap>
											<input type="text" maxlength="80" size="50" disabled tabindex="-1"
											value="#rsLinea.Cdescripcion#">
										</td>
									</tr>
								</table>
							</cfoutput>
							</td>
						<cfelse>
						<td></td>
						</cfif>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap align="right"><cf_translate key="descripcion">Descripci&oacute;n</cf_translate>:</td>
							<td>
								<input name="Ddescripcion" type="text" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Ddescripcion#</cfoutput><cfelse><cfoutput>#rsDocumento.Edescripcion#</cfoutput></cfif>" size="60" maxlength="100" onFocus="javascript:this.select();"> 
							<cfif modo EQ "CAMBIO" and Not ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)>
								<script language="JavaScript">document.form1.Cmayor.focus();</script> 
							</cfif>
							</td>
							<td nowrap align="right"><cf_translate key="oficina">Oficina</cf_translate>:&nbsp;</td>
							<td> 
								<select name="Ocodigo">
									<cfoutput query="rsOficinas"> 
										<option value="#rsOficinas.Ocodigo#" <cfif modoDet NEQ "ALTA" and rsOficinas.Ocodigo EQ rsLinea.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap align="right"><cf_translate key='documento'>Documento</cf_translate>:&nbsp;</td>
							<td nowrap> 
								<table border="0" width="100%">
									<tr>
										<td>
											<input type="text" name="Ddocumento" size="25" maxlength="20" value="<cfoutput><cfif modoDet NEQ "ALTA">#rsLinea.Ddocumento#<cfelse>#rsDocumento.Edocbase#</cfif></cfoutput>" onFocus="this.select();">
										</td>	
										<td align="right">Moneda:&nbsp;</td>
										<td width="1%">
											<cfif modoDet NEQ "ALTA">
												<cf_sifmonedas query="#rsLinea#" valuetc="#rsLinea.Dtipocambio#" onchange="sugerirTC();get_montoLocal();">
											<cfelse>
												<cf_sifmonedas onchange="sugerirTC();get_montoLocal();">
											</cfif>
										</td>	
									</tr>
								</table>
							</td>
							<td nowrap align="right">Tipo Cambio:&nbsp;</td>
							<td nowrap>
								<input name="Dtipocambio" type="text" 
								onChange="javascript:get_montoLocal();" 
								onBlur='javascript:this.disabled=false; validaNumero(this,4);'
								onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"					
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dtipocambio#</cfoutput><cfelse>0.00</cfif>" size="20" maxlength="20"> 
							</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap align="right">Monto Origen:&nbsp;</td>
							<td>
								<input name="Doriginal" type="text" 
								onChange="javascript:get_montoLocal();" 
								onBlur="javascript: if(validaNumero(this,2)){get_montoLocal();formatCurrency(this,2);}"
								onFocus="javascript:this.select();"
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"					
								value="<cfif modoDet NEQ "ALTA"><cfoutput>#lscurrencyformat(rsLinea.Doriginal,'none')#</cfoutput><cfelse>0.00</cfif>" size="20" maxlength="20"> 
							</td>
							<td valign="baseline" nowrap align="right">Monto Local:&nbsp;</td>
							<td valign="baseline">
								<input name="Dlocal" type="text" value="<cfif modoDet NEQ "ALTA"><cfoutput>#lscurrencyformat(rsLinea.Dlocal,'none')#</cfoutput></cfif>" size="20" maxlength="20" disabled>
							</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td nowrap>&nbsp;</td>
							<td>
								<input type="hidden" name="_Ccuenta"> <input type="hidden" name="_CFcuenta">
								<input type="hidden" name="_Dmovimiento"> 
								<input type="hidden" name="_Ocodigo"> <input type="hidden" name="_Ddescripcion"> 
								<input type="hidden" name="_Mcodigo"> <input type="hidden" name="_Dtipocambio"> 
								<input type="hidden" name="_Doriginal"> <input type="hidden" name="_Dlocal"> 
								
							<td>
								<cfset tsD = "">
								<cfif modoDet NEQ "ALTA">
									<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD"></cfinvoke>
								</cfif>
							</td>
							<td>
								<input type="hidden" name="Dlinea" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dlinea#</cfoutput></cfif>"> 
								<input type="hidden" name="Dreferencia" value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.Dreferencia#</cfoutput></cfif>"> 
								<input type="hidden" name="timestampD" value="<cfif modoDet NEQ "ALTA"><cfoutput>#tsD#</cfoutput></cfif>"> 
								<input type="hidden" name="bandBalancear" value="N">
								<input type="hidden" name="borrarLista" value="N">
								<input type="hidden" name="CcuentaBalancear" value="<cfif isdefined('rsParamCuentaBalance') and rsParamCuentaBalance.recordCount GT 0><cfoutput>#rsParamCuentaBalance.Ccuenta#</cfoutput></cfif>">
								<input type="hidden" name="CFcuentaBalancear" value="<cfif isdefined('rsParamCuentaBalance') and rsParamCuentaBalance.recordCount GT 0><cfoutput>#rsParamCuentaBalance.CFcuenta#</cfoutput></cfif>">
							</td>
						</tr>
						<script language="JavaScript">AsignarHiddensDet();</script>
					</table>
				</td>
			</tr>
		</cfif>
		<!---------------------------------------------------------------------------------->
		<tr> 
			<td colspan="10" align="center">
		<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
				<cfif rsDocumento.ECauxiliar NEQ "S" and PermisoModificar>
					<cfif modoDet EQ "ALTA">
						<input name="AgregarD" type="submit" value="Agregar Lin." onClick="javascript: return valida('AgregarD');">
					<cfelse>
						<cfif not isdefined("rsLinea.Ddescripcion") OR rsLinea.Ddescripcion NEQ 'Ajuste para balancear diferencias en tipos de cambio'>
						<input name="CambiarD" type="submit" value="Cambiar Lin." onClick="javascript:return valida('CambiarD');">
						</cfif>
						<!--- <input name="BorrarD" type="submit" value="Borrar Linea" onClick="javascript:if (confirm('Desea borrar esta lnea del documento?')) return true; else return false;"> --->
						<input name="NuevoD" type="submit" value="Nueva Lin.">
					</cfif>
					&nbsp;
				</cfif>
		</cfif>
				<cfif modo EQ "ALTA"> 
					<input type="submit" name="AgregarE" value="Agregar Doc.">
				<cfelse>
					<cfif rsTieneLineas.RecordCount GT 0>
						<!--- Validar si se puede aplicar --->
						<cfif PermisoAplicar>
							<input type="submit" name="Aplicar" value="Aplicar Doc." onClick="javascript:return Postear();">
						</cfif>
						<!--- <cf_popup boton="true" url="CDContables.cfm?Id=#IDContable#" link="Consultar Doc." status="yes" resize="yes" scrollbars="yes" height="450" top="150"> --->
						<input type="button" name="ConsultarDoc" value="Consultar Doc." onClick="javascript:location.href='CDContables<cfoutput>#sufix#</cfoutput>.cfm?Id=<cfoutput>#IDContable#</cfoutput>&inter=<cfoutput>#inter#</cfoutput>';">
					</cfif>
					<input type="button" name="Exportar" value="Exportar Doc." onClick="javascript:exportar();">
					<cfif poneBtnBalancear>
						<input type="button" name="btnBalancear" value="Balancear Doc." onClick="javascript:validaParametro();">																		
					</cfif>
					
					<cfif Not ((isdefined("rsDocumento.ECauxiliar") and rsDocumento.ECauxiliar EQ "S") or not PermisoModificar)>
						<input type="submit" name="BorrarE" value="Eliminar Doc." onClick="javascript: document.form1.Ccuenta.value = '-1'; document.form1.CFcuenta.value = '-1'; document.form1.Ddescripcion.value = '.'; if (confirm('Desea borrar este documento?')) return true; else return false;">
					</cfif>					
					<input type="submit" name="NuevoE" value="Nuevo Doc." onClick="javascript: deshabilitarValidacion();">
					<cfif PermisoModificar>
						<input type="button" name="btnArchivos" value="Docs. Soporte" onClick="javascript:funcArchivo(1);">									
					<cfelseif PermisoVisualizar>
						<input type="button" name="btnArchivos" value="Docs. Soporte" onClick="javascript:funcArchivo(2);">
					</cfif>
				</cfif>
				<cfif modo EQ "CAMBIO" and rsDocumento.ECestado EQ 0>
					<input type="submit" name="btnCerrar" value="Cerrar" onClick="javascript: deshabilitarValidacion();">
				<cfelse>
					<input type="submit" name="btnAbrir" value="Abrir" onClick="javascript: deshabilitarValidacion();">
				</cfif>
				&nbsp;&nbsp;<input type="button" name="ListaE" value="Ir a Lista" onClick="javascript:Lista();">					
			</td>			
		</tr>
	</table>
	<input type="hidden" name="inter" value="<cfoutput>#inter#</cfoutput>">
	<cfif inter neq "S">
			<input type="hidden" name="Ecodigo_Ccuenta" value="<cfoutput>#Session.Ecodigo#</cfoutput>">
	</cfif>
</form>

<script language="JavaScript" type="text/javascript">		
	<cfif not isDefined("Form.NuevoE") and modo NEQ "ALTA">
		if(document.form1.Ecodigo_Ccuenta){
			function CambiarOficina(){
				var oCombo   = document.form1.Ocodigo;
				var EcodigoI = document.form1.Ecodigo_Ccuenta.value;
				var cont = 0;
				oCombo.length=0;
				<cfoutput query="rsOficinas">
				if ('#Trim(rsOficinas.Ecodigo)#' == EcodigoI ){
					oCombo.length=cont+1;
					oCombo.options[cont].value='#Trim(rsOficinas.Ocodigo)#';
					oCombo.options[cont].text='#Trim(rsOficinas.Odescripcion)#';
					<cfif  isdefined("rsLinea") and rsLinea.Ocodigo eq rsOficinas.Ocodigo >
						oCombo.options[cont].selected = true;
					</cfif>
				cont++;
				};
				</cfoutput>
			}
			CambiarOficina();
		}	
	</cfif>
		function validaParametro() {
			if(confirm("Desea generar las lneas de asiento necesarias para balancear esta pliza?")){
				<cfif isdefined('rsParamCuentaBalance') and (rsParamCuentaBalance.Ccuenta EQ '' OR rsParamCuentaBalance.CFcuenta EQ '')>
					alert('No se ha parametrizado la cuenta de balance en los parmetros del sistema');	
					document.form1.bandBalancear.value='N';
				<cfelse>
					document.form1.bandBalancear.value='S';
				document.form1.Edocumento.disabled = false;
				document.form1.Cconcepto.disabled = false;					
					document.form1.submit();
				</cfif>
			}
		}
		
		/* aqu asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
		<cfif modo NEQ "ALTA">
			if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
				formatCurrency(document.form1.TC,2);
				document.form1.Dtipocambio.disabled = true;			
			}		
			document.form1.Dtipocambio.value = document.form1.TC.value;
		</cfif>
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		sugerirTClocal();
		get_montoLocal();
		Deshabilitar();
	
		function valida(boton) {
		
			if (boton == "AgregarD") {
				var estado_Dtipocambio = document.form1.Dtipocambio.disabled;
				var estado_Doriginal = document.form1.Doriginal.disabled;
				var estado_Dlocal = document.form1.Dlocal.disabled;
				var estado_Cconcepto = document.form1.Cconcepto.disabled;
				<cfif modo EQ "ALTA">
				var estado_Eperiodo = document.form1.Eperiodo.disabled;
				var estado_Emes = document.form1.Emes.disabled;
				</cfif>
	
				document.form1.Dtipocambio.disabled = false;
				document.form1.Doriginal.disabled = false;
				document.form1.Dlocal.disabled = false;
				document.form1.Cconcepto.disabled = false;
				document.form1.Eperiodo.disabled = false;
				document.form1.Emes.disabled = false;
			}
			
			if (boton == "CambiarD") {
				var estado_Dtipocambio = document.form1.Dtipocambio.disabled;
				var estado_Doriginal = document.form1.Doriginal.disabled;
				var estado_Dlocal = document.form1.Dlocal.disabled;
	
				document.form1.Dtipocambio.disabled = false;
				document.form1.Doriginal.disabled = false;
				document.form1.Dlocal.disabled = false; 			
			}	
			
			var dioError = false;
	
			if (!dioError && objForm.Cdescripcion.isNotEmpty() == false) {
				mensaje = 'Debe seleccionar una cuenta';
				alert(mensaje);
				dioError = true;
			}
	
			if (!dioError && objForm.Ddescripcion.isNotEmpty() == false) {
				alert("Debe digitar una Descripcion");
				dioError = true;
			}
	
			if (!dioError && objForm.Ddocumento.isNotEmpty() == false) {
				alert("Debe digitar el documento (detalle)");
				dioError = true;
			}
	
			if (!dioError && !validaNumero(document.form1.Doriginal,2))  {
				document.form1.Doriginal.select();
				dioError = true;
			}
			
			if (!dioError && !validaNumero(document.form1.Dlocal,2)) {
				document.form1.Dlocal.select();
				dioError = true;
			}	
			if (!dioError && !validaNumero(document.form1.Dtipocambio,4)) {
				document.form1.Dtipocambio.select();
				dioError = true;
			}
			
			if (!dioError && new Number(document.form1.Doriginal.value) == 0 ) {
				alert("El monto debe ser mayor que cero");
				document.form1.Doriginal.select();
				dioError = true;
			}
			if (!dioError && new Number(document.form1.Dtipocambio.value) == 0 ) {
				alert("El monto debe ser mayor que cero");
				document.form1.Dtipocambio.select();
				dioError = true;
			}
			
			// Activa o desactiva los campos que se necesitaban para el post, segn el botn que se presion
			if (dioError) {
				if (boton == "AgregarD") {				
					document.form1.Dtipocambio.disabled = estado_Dtipocambio;
					document.form1.Doriginal.disabled = estado_Doriginal;
					document.form1.Dlocal.disabled = estado_Dlocal;
					document.form1.Cconcepto.disabled = estado_Cconcepto;
					//document.form1.Eperiodo.disabled = true;
					//document.form1.Emes.disabled = estado_Emes;
					document.form1.Eperiodo.disabled = false;
					document.form1.Emes.disabled = false;
				}
				if (boton == "CambiarD") {
					document.form1.Dtipocambio.disabled = estado_Dtipocambio;
					document.form1.Doriginal.disabled = estado_Doriginal;
					document.form1.Dlocal.disabled = estado_Dlocal;			
				}			
				return false;
			}		
			return true;
		}
	
	
		function get_montoLocal(){
			<cfif modo NEQ "ALTA">
			var estant = document.form1.Dtipocambio.disabled;
				document.form1.Dtipocambio.disabled = false;
				document.form1.Dlocal.disabled = false;
				var t = qf(document.form1.Dtipocambio.value);
				var m = qf(document.form1.Doriginal.value);
				var r = 0;
	
				if (new Number(t)!=0){			
					r = new Number(m) * new Number(t);
					document.form1.Dlocal.value =  redondear(r,2);
					formatCurrency(document.form1.Dlocal,2);
				}
				document.form1.Dlocal.disabled = true;		
				document.form1.Dtipocambio.disabled = estant;
			</cfif>
		}
		
		function sugerirTC() {		
			 <cfif modo NEQ "ALTA">
				document.form1.Dtipocambio.disabled = false;
				if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")  {
					document.form1.Dtipocambio.value = "1.00";
					document.form1.Dtipocambio.disabled = true;	
				}		
				else {
						<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
						//Verificar si existe en el recordset
						var nRows = rsTCsug.getRowCount();
						if (nRows > 0) {
							for (row = 0; row < nRows; ++row)
							{
								if (rsTCsug.getField(row, "Mcodigo") == document.form1.Mcodigo.value) {
									document.form1.Dtipocambio.value = rsTCsug.getField(row, "TCcompra");
									break;
								}
								else
									document.form1.Dtipocambio.value = "0.00";					
							}
						}
						else
							{
								document.form1.Dtipocambio.value = "0.00";
							}
					document.form1.Dtipocambio.disabled = false;	
				}
				<cfif rsDocumento.ECauxiliar EQ "S"> 
					Deshabilitar();		
				</cfif>
			</cfif>
		}
		
		function Postear(){
			if (confirm('Desea aplicar este documento?')) {
				document.form1.Ccuenta.value = '-1';
				document.form1.CFcuenta.value = '-1';
				document.form1.Ddescripcion.value = '.';
				document.form1.Cconcepto.disabled = false;
				document.form1.Eperiodo.disabled = false;
				document.form1.Emes.disabled = false;
				document.form1.Edocumento.disabled = false; 
				var correcto = true;
				<cfif isdefined("rsBalanceO")>
				<cfloop query="rsBalanceO">
					<cfif rsBalanceO.Creditos - rsBalanceO.Debitos NEQ 0 or rsBalanceO.CreditosL - rsBalanceO.DebitosL NEQ 0>
						<cfif inter EQ 'N'>
							alert('La poliza no esta balanceada para la Moneda <cfoutput>#rsBalanceO.Mnombre#</cfoutput> en la Oficina <cfoutput>#rsBalanceO.Odescripcion#!</cfoutput>');
						<cfelse>
							alert('La poliza no esta balanceada para la Moneda <cfoutput>#rsBalanceO.Mnombre#</cfoutput>');
						</cfif>
						correcto = false;
						<cfbreak>
					</cfif>
				</cfloop>
				</cfif>
				if (correcto==false) {
				document.form1.Ccuenta.value = '';
				document.form1.CFcuenta.value = '';
				document.form1.Ddescripcion.value = '';
				}
				return correcto;
			} 
			else return false; 	
		}
	
	function sugerirTClocal() {
		<cfif modoDet EQ "ALTA" and modo NEQ "ALTA">
			document.form1.Mcodigo.onchange(); 
		</cfif>
		<cfif modo NEQ "ALTA">
			//document.form1.Eperiodo.disabled=true;
			//document.form1.Emes.disabled=true;
			document.form1.Cconcepto.disabled=true;
		</cfif>
		return;
	}	
	
	function exportar() {
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		<cfif modo neq 'ALTA'>
			window.open('exportarPoliza.cfm?IDcontable=<cfoutput>#IDcontable#</cfoutput>', 'Modulos','menu=no,scrollbars=yes,top='+top+',left='+left+',width=350,height=200');
		</cfif>			
	}
	
	function _finalizar(){
		<cfif isdefined("paramretro")>															
			document.form1.paramretro.disabled = false;
		</cfif>		
		document.form1.Edocumento.disabled = false;
		document.form1.Cconcepto.disabled = false;
		<cfif modo NEQ "ALTA">
			document.form1.Dlocal.value=qf(document.form1.Dlocal);
			document.form1.Doriginal.value=qf(document.form1.Doriginal);
		</cfif>
	}
	
	function deshabilitarValidacion(){
		<cfif modoDet NEQ "ALTA">			
			objForm.Cconcepto.required = false;
			objForm.Edescripcion.required= false;
			objForm.Efecha.required= false;
			objForm.Edocbase.required= false;
			objForm.Ddocumento.required= false;
		</cfif>
		objForm.Ccuenta.required = false;
		objForm.CFcuenta.required = false;
		objForm.Ddescripcion.required= false;
		objForm.Ocodigo.required= false;
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.Cconcepto.required = true;
		objForm.Cconcepto.description="Concepto";		
		//objForm.Eperiodo.required= true;
		//objForm.Eperiodo.description="Periodo";			
		//objForm.Emes.required= true;
		//objForm.Emes.description="Mes";			
		objForm.Edescripcion.required= true;
		objForm.Edescripcion.description="Descripcion";			
		objForm.Efecha.required= true;
		objForm.Efecha.description="Fecha";			
		objForm.Edocbase.required= true;
		objForm.Edocbase.description="Documento";	
	<cfelse>
		<cfif modoDet NEQ "ALTA">			
			objForm.Cconcepto.required = true;
			objForm.Cconcepto.description="Concepto";		
			//objForm.Eperiodo.required= true;
			//objForm.Eperiodo.description="Periodo";			
			//objForm.Emes.required= true;
			//objForm.Emes.description="Mes";			
			objForm.Edescripcion.required= true;
			objForm.Edescripcion.description="Descripcion";			
			objForm.Efecha.required= true;
			objForm.Efecha.description="Fecha";			
			objForm.Edocbase.required= true;
			objForm.Edocbase.description="Documento";
			objForm.Ddocumento.required= true;
			objForm.Ddocumento.description="Documento";
		</cfif>
		objForm.Ccuenta.required = true;
		objForm.CFcuenta.required = true;
		objForm.Ccuenta.description="Cuenta";
		objForm.CFcuenta.description="Cuenta Financiera";
		objForm.Ddescripcion.required= true;
		objForm.Ddescripcion.description="Descripcion";			
		objForm.Ocodigo.required= true;
		objForm.Ocodigo.description="Oficina";
	</cfif>		
</script>

