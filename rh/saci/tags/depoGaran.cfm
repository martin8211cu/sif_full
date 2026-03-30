<cfparam	name="Attributes.Gid"				type="string"	default="">						<!--- Id de ISBgarantia --->
<cfparam	name="Attributes.CTid"				type="string"	default="">						<!--- Id de Cuenta --->
<cfparam	name="Attributes.idpersona"			type="string"	default="">						<!--- Id de la Persona que posee el contrato --->
<cfparam	name="Attributes.LGlogin"			type="string"	default="">						<!--- LGlogin utilizado para cuando no se manda el Contratoid, sino que se usa el Id de la Persona, el PQcodigo y el Login para consultar el monto a pagar por deposito de garantia --->
<cfparam	name="Attributes.idcontrato"		type="string"	default="">						<!--- Id de un contrato seleccionado dentro de la cuenta --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.sufijo"	 		type="string"	default="">						<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.form"	 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.PQcodigo"			type="string"	default="">						<!--- PQcodigo del paquete del contrato --->
<cfparam 	name="Attributes.PQcodigo_cambio"	type="string"	default="">						<!--- PQcodigo del paquete destino para un cambio de paquete --->
<cfparam 	name="Attributes.creaCTid"	 		type="boolean"	default="true">					<!--- Crea o no el campo oculto CTid (id de la cuenta) --->
<cfparam 	name="Attributes.verOpciones"		type="boolean"	default="true">					<!--- Permite ocultar o no la liga para abrir o no la linea con las opciones --->
<cfparam 	name="Attributes.creaMP" 			type="string"	default="">						<!--- crea o no un oculto con el monto a pagar --->
<cfparam 	name="Attributes.codTipos" 			type="string"	default="">						<!--- Lista de los codigos de los tipos que se desea que aparezcan en el combo de tipos --->

<cfset ExisteCuenta = (isdefined("Attributes.CTid") and Len(Trim(Attributes.CTid)) and isdefined("Attributes.idpersona") and Len(Trim(Attributes.idpersona)))>
<cfset ExisteContrato = (ExisteCuenta and isdefined("Attributes.idcontrato") and Len(Trim(Attributes.idcontrato)))>

<cfif not isdefined('session.saci.depositoGaranOK')>
	<cfset session.saci.depositoGaranOK = true>
</cfif>

<cfoutput>
	
	<!--- Si existe el Attributes.PQcodigo entonces se consulta solo el paquete porque significa que se va a realizar un cambio de paquete
		, por tal razon el PQcodigo que se pasa por parametro será el nuevo paquete por el que se va a hacer el cambio --->
	<cfif isdefined('Attributes.PQcodigo_cambio') and Attributes.PQcodigo_cambio NEQ "">
		<cfquery name="rsGarant" datasource="#Attributes.Conexion#">
			Select 	PQcodigo
					, PQdescripcion
					, 0 as montoPaga
					, '' as moneda
					, 1 as tipoCambio
					, '' as Gid
					, -1 as Gtipo
					, 0 as Gmonto
					, '' as EFid
					, '' as Gref
					, '' as Ginicio
					, '' as Gcustodio
					, '' as Gobs
					, '' as permitecargofijo
					, '1' as CTcondicion
			from ISBpaquete
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
				and PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.PQcodigo_cambio#">
		</cfquery>
	<cfelse>
		<cfquery name="rsGarant" datasource="#Attributes.Conexion#">
			select b.Gid, b.EFid, b.Miso4217, b.Gtipo, b.Gref, b.Gmonto, b.Ginicio, b.Gvence, b.Gcustodio, b.Gestado, b.Gobs,
				   c.PQcodigo, c.PQdescripcion, a.Contratoid	,
				   0 as montoPaga, '' as moneda, 1 as tipoCambio
				   , '' as permitecargofijo, a.CTcondicion
			from ISBproducto a
				left outer join ISBgarantia b
					on b.Contratoid = a.Contratoid
						<cfif isdefined('Attributes.Gid') and Attributes.Gid NEQ ''>
							and b.Gid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Gid#">
						</cfif>					
				inner join ISBpaquete c
					on c.PQcodigo = a.PQcodigo
						<cfif isdefined('Attributes.PQcodigo') and Attributes.PQcodigo NEQ ''>
							and c.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.PQcodigo#">
						</cfif>
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.CTid#">
				<cfif ExisteContrato>
					and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
				</cfif>			
		</cfquery>	
	</cfif>

	<cfquery name="rsvendedores" datasource="#Attributes.Conexion#">
		Select ag.AAinterno 
			from ISBagente ag
			left join ISBvendedor ve
			on ag.AGid = ve.AGid
		Where Vid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.vendedor.id#">	
	</cfquery>
	
	<cfif isdefined('rsGarant') and rsGarant.RecordCount gt 0>
	<cfquery name="rsMRcodigo" datasource="#Attributes.Conexion#">
		Select MRcodigo 
			from ISBpaquete paq
			inner join ISBmayoristaRed may
			on paq.MRidMayorista = may.MRidMayorista
		Where paq.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGarant.PQcodigo#">
	</cfquery>
	</cfif>
	
<!---2	CAJAS DE RACSA
3	DEPOSITO BANCARIO
4	ACTUALIZACION MANUAL
5	AJUSTES
6	ACTUALIZACION POR CJ
7	TRASLADO DEPOSITO
8	PAGO CAJAS (FECHA PREVIA)
9	RECIBO POR DINERO RACSA
10	RECIBO POR DINERO ICE
1	CARGOS FIJOS
11	PAGO EN LINEA--->

	<cfif Attributes.codTipos eq ''>
		<cfif rsvendedores.AAinterno eq 1 and Not ListFind('CT,AM,ICE', trim(rsMRcodigo.MRcodigo))>
			<cfset Attributes.codTipos = '2,3,7,9'>
		<cfelseif rsvendedores.AAinterno eq 0 and Not ListFind('CT,AM,ICE', trim(rsMRcodigo.MRcodigo))>
			<cfset Attributes.codTipos = '2,3'>
		<cfelseif ListFind('CT,AM', trim(rsMRcodigo.MRcodigo))>
			<cfset Attributes.codTipos = '1,2,3'>
		<cfelseif ListFind('ICE', trim(rsMRcodigo.MRcodigo))>
			<cfset Attributes.codTipos = '10,3'>	
		<cfelse>
			<cfset Attributes.codTipos = ''>	
		</cfif>
	</cfif>
	<cfquery name="rsTipos" datasource="#Attributes.Conexion#">
		select FIDCOD,FIDDES  
		from SSXFID
		<cfif Attributes.codTipos NEQ ''>
			where FIDCOD in (#Attributes.codTipos#)
		</cfif>
		Order by FIDCOD
	</cfquery>	
	
	<cfif rsGarant.RecordCount GT 0>
		<!--- Averiguar el monto a pagar para el contrato(paquete) asociado a la cuenta --->
		<cfif ExisteContrato>
			<cfinvoke component="saci.comp.WSinvoke" method="Get_DepositoGarantia"
				returnvariable="retGarantia"
				PQcodigo="#rsGarant.PQcodigo#"
				Contratoid="#Attributes.idcontrato#"/>
		<cfelse>
			<cfif isdefined('Attributes.LGlogin') and Attributes.LGlogin NEQ ''
				and isdefined('Attributes.idpersona') and Attributes.idpersona NEQ ''>
					<cfinvoke component="saci.comp.WSinvoke" method="Get_DepositoGarantia"
						returnvariable="retGarantia"
						PQcodigo="#rsGarant.PQcodigo#"
						LGlogin="#Attributes.LGlogin#"
						Pquien="#Attributes.idpersona#"/>						
			<cfelse>
				<cfthrow message="Error, para el tag de depoGaran, si el parametro idContrato no se pasa, entonces son requeridos el LGlogin y el idpersona.">
			</cfif>
		</cfif>

		<cfset rsGarant.montoPaga = retGarantia.monto>
		<cfset rsGarant.moneda = retGarantia.moneda>
		<cfset rsGarant.tipoCambio = retGarantia.tipoCambio>
		<cfset rsGarant.permitecargofijo = retGarantia.permitecargofijo>		

		<cfif isdefined("Attributes.creaMP") and Len(Trim(Attributes.creaMP))>
			<input type="hidden" name="#Attributes.creaMP##Attributes.sufijo#" id="#Attributes.creaMP##Attributes.sufijo#" value="#rsGarant.montoPaga#">		
		</cfif>
		<cfif isdefined("rsGarant") and Len(Trim(rsGarant.Gid))>
			<input type="hidden" name="Gid#Attributes.sufijo#" id="Gid#Attributes.sufijo#" value="#rsGarant.Gid#">							
		</cfif>
		<cfif ExisteContrato>
			<input type="hidden" name="Contratoid#Attributes.sufijo#" id="Contratoid#Attributes.sufijo#" value="#Attributes.idcontrato#">				
		</cfif>		
	</cfif>		

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<cfinclude template="../utiles/depoGaran.cfm">
		</td>
	  </tr>
	</table>

	<script language="javascript" type="text/javascript">
		function abrePago#Attributes.sufijo#(opc) {

			if(document.getElementById('estadoCampos#Attributes.sufijo#').value == 1)
				document.getElementById('cierra#Attributes.sufijo#').style.display='';
			else
				document.getElementById('cierra#Attributes.sufijo#').style.display='none';
			
			if(document.getElementById('estadoCampos#Attributes.sufijo#').value == 0)
				document.getElementById('estadoCampos#Attributes.sufijo#').value = 1;
			else
				document.getElementById('estadoCampos#Attributes.sufijo#').value = 0
		}
		
		function validarDepoGaran#Attributes.sufijo#() {		
			var error_inputDG;
			var error_msgDG = '';
			
			//toma la fecha actual.
			var d,fecha,hoy = "";		d = new Date();		hoy += (d.getUTCMonth() + 1) + "/";		hoy += d.getUTCDate() + "/";	hoy += d.getUTCFullYear();
			
			<cfif isdefined('rsGarant') and rsGarant.montoPaga GT 0>
				if(document.#Attributes.form#.Gtipo#Attributes.sufijo#.value == 0){
					error_msgDG += "\n - El Monto para el producto #rsGarant.PQdescripcion# es requerido.";
					error_inputDG = document.getElementById("Gtipo#Attributes.sufijo#");
				}			
				if(document.#Attributes.form#.Gtipo#Attributes.sufijo#.value == '3' || document.#Attributes.form#.Gtipo#Attributes.sufijo#.value == '9' || document.#Attributes.form#.Gtipo#Attributes.sufijo#.value == '10'){
					if(document.#Attributes.form#.Gmonto#Attributes.sufijo#.value == 0){
						error_msgDG += "\n - El Monto para el producto #rsGarant.PQdescripcion# es requerido.";
						error_inputDG = document.getElementById("Gmonto#Attributes.sufijo#");
					}
					if(document.#Attributes.form#.EFid#Attributes.sufijo#.value ==""){
						error_msgDG += "\n - El Banco para el producto #rsGarant.PQdescripcion# es requerido.";
						error_inputDG = document.getElementById("EFid#Attributes.sufijo#");
					}
					if(document.#Attributes.form#.Gref#Attributes.sufijo#.value ==""){	
						error_msgDG += "\n - La Referencia para el producto #rsGarant.PQdescripcion# es requerida.";
						error_inputDG = document.getElementById("Gref#Attributes.sufijo#");
					}													
					
					if (! (/^[0-9]*$/.test(document.#Attributes.form#.Gref#Attributes.sufijo#.value))) 
					
					{
						error_msgDG += "\n - La Referencia no es válida para el producto #rsGarant.PQdescripcion# es requerida.";
						error_inputDG = document.getElementById("Gref#Attributes.sufijo#");
					}
					
					
					if(document.#Attributes.form#.Ginicio#Attributes.sufijo#.value ==""){
						error_msgDG += "\n - La Fecha para el producto #rsGarant.PQdescripcion# es requerida.";
						error_inputDG = document.getElementById("Ginicio#Attributes.sufijo#");
					}
					
					else{
						var f=document.#Attributes.form#.Ginicio#Attributes.sufijo#.value; //mascara de fecha actual dd/mm/yyyy
						fecha = f.charAt(3)+f.charAt(4) +'/'+ f.charAt(0)+f.charAt(1) +'/'+ f.charAt(6)+f.charAt(7)+f.charAt(8)+f.charAt(9);//mascara nueva mm/dd/yyyy
						if( Date.parse(hoy) < Date.parse(fecha)){
							error_msgDG += "\n - La Fecha para el producto #rsGarant.PQdescripcion# debe ser menor a la fecha de hoy.";
							error_inputDG = document.getElementById("Ginicio#Attributes.sufijo#");
						}
					}
				}
				var resMontoOK = montoOK#Attributes.sufijo#(#rsGarant.montoPaga#,'#rsGarant.moneda#',#rsGarant.tipoCambio#);
				
				if(	resMontoOK > -1){
					error_msgDG += "\n - Atención :  El monto a pagar por el Paquete #rsGarant.PQdescripcion# es de #rsGarant.montoPaga# (#rsGarant.moneda#)\n, se debe ingresar un monto de " + fm(resMontoOK,2) + ", según la moneda seleccionada.";
				}
			</cfif>
			<!--- Validacion terminada --->
			if (error_msgDG.length != "") {	
				alert("Por favor revise los siguiente datos:"+error_msgDG);				
				if (error_inputDG && error_inputDG.focus) 
					error_inputDG.focus();					
				return false;
			}else {
				return true;
			}
		}

		<cfif isdefined('rsGarant') and rsGarant.montoPaga GT 0>
			/* Validacion del monto para el deposito de garantia, que no sea menor que el devuelto por la interfaz, dependiendo de la moneda
				seleccionada por el usuario. */	
			function montoOK#Attributes.sufijo#(montoPagar,monedaINT,tcINT){
				var tipo = eval('document.#Attributes.form#.Gtipo#Attributes.sufijo#.value;');
				var monto = eval('qf(document.#Attributes.form#.Gmonto#Attributes.sufijo#.value);');		
				var montoConver = new Number(monto);					
				var moneda = eval('document.#Attributes.form#.Miso4217#Attributes.sufijo#.value;');
				var tcINTconvert = new Number(tcINT);
				var tcFinal = tcINTconvert;
				var montoApagar = new Number(montoPagar);		
		
				if((tipo==3)||(tipo==9)||(tipo==10)){	//3.Deposito Bancario,   9.Recibo x dinero Racsa,   10.Recibo x dinero ICE
					if(moneda == monedaINT)//Revisar que la moneda del Deposito de Garantia sea la misma 
						tcFinal = 1;
					else
						tcFinal = tcINTconvert;
					montoApagar = montoApagar * tcFinal;					
					if(montoConver < montoApagar)
						return montoApagar;							
				}else{	
					eval("document.#Attributes.form#.Miso4217#Attributes.sufijo#.value='" + monedaINT + "';");
					eval("document.#Attributes.form#.Gmonto#Attributes.sufijo#.readonly=true;");						
					tcFinal = 1;
				}
		
				return -1;
			}		
			function cambioTipo#Attributes.sufijo#(obj){
				if((obj.value!=3)&&(obj.value!=9)&&(obj.value!=10)){
					
					eval("document.#Attributes.form#.Gmonto#Attributes.sufijo#.value=#rsGarant.montoPaga#;");	
					eval("document.#Attributes.form#.Gmonto#Attributes.sufijo#.readOnly=true;");					
					eval("document.#Attributes.form#.Gref#Attributes.sufijo#.value='';");
					eval("document.#Attributes.form#.Gcustodio#Attributes.sufijo#.value='';");
					eval("document.#Attributes.form#.Gobs#Attributes.sufijo#.value='';");
					eval("document.#Attributes.form#.Miso4217#Attributes.sufijo#.value='#rsGarant.moneda#';");					
					eval("document.#Attributes.form#.EFid#Attributes.sufijo#.value='';");
					
					document.getElementById("monedaOK#Attributes.sufijo#").style.display='none';
					document.getElementById("monReadonly#Attributes.sufijo#").style.display='';
					
					document.getElementById("bancoyReferencia#Attributes.sufijo#").style.display='none';
					document.getElementById("fechaycustodio#Attributes.sufijo#").style.display='none';
					document.getElementById("tobservaciones#Attributes.sufijo#").style.display='none';	
					
					eval("document.#Attributes.form#.Gref#Attributes.sufijo#.readOnly=false;");
					eval("document.#Attributes.form#.Gcustodio#Attributes.sufijo#.readOnly=false;");
					eval("document.#Attributes.form#.Gobs#Attributes.sufijo#.readOnly=false;");
				}else{
					eval("document.#Attributes.form#.Gref#Attributes.sufijo#.readOnly=false;");
					eval("document.#Attributes.form#.Gcustodio#Attributes.sufijo#.readOnly=false;");
					eval("document.#Attributes.form#.Gobs#Attributes.sufijo#.readOnly=false;");
					eval("document.#Attributes.form#.Gmonto#Attributes.sufijo#.readOnly=false;");
					
					document.getElementById("monedaOK#Attributes.sufijo#").style.display='';
					document.getElementById("monReadonly#Attributes.sufijo#").style.display='none';		
					document.getElementById("bancoyReferencia#Attributes.sufijo#").style.display='';
					document.getElementById("fechaycustodio#Attributes.sufijo#").style.display='';
					document.getElementById("tobservaciones#Attributes.sufijo#").style.display='';	
				
					if (obj.value == 10) {						
						eval("document.#Attributes.form#.EFid#Attributes.sufijo#.value = '0001';");
						document.getElementById("bancoyReferencia#Attributes.sufijo#").style.display='none';
					}
				}
			}		
			function cambiaTipos#Attributes.sufijo#(){
				cambioTipo#Attributes.sufijo#(document.#Attributes.form#.Gtipo#Attributes.sufijo#);
			}
			cambiaTipos#Attributes.sufijo#();	
			abrePago#Attributes.sufijo#();	
		</cfif>
			<cfif Attributes.verOpciones and rsGarant.CTcondicion neq '0'>	
				abrePago#Attributes.sufijo#();	
			</cfif>
	</script>
</cfoutput>
