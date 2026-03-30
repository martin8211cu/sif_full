<cfset title1="Registro de Estados de Cuenta">
<cfset title2="Lista de Estados de Cuenta">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfset LvarIrARPregistrMasive="../Reportes/RPRegistroEstadosCtasMasivo.cfm">
<cfset LvarIrARPRegisMovBanc="../Reportes/RPRegistroMovBancarios.cfm">
<cfset LvarIrAEC="EstadosCuenta.cfm">
<cfset LvarEtiqueta ="Banco, Cuenta Bancaria, Documento, Fecha"> 
<CFSET LvarFormatos ="S,S,S,D"> 
<CFSET LvarAlign ="left,left,left,left"> 
<CFSET LvarFiltrar ="b.Bid, c.CBid, a.ECdescripcion,a.EChasta"> 
<CFSET lvarFiltro= "b.Ecodigo = #Session.Ecodigo#
				  and c.CBesTCE = #LvarCBesTCE#
				  and a.Bid = b.Bid 
				  and a.CBid = c.CBid 
				  and a.EChistorico = 'N'
				  and a.ECaplicado = 'N' order by a.Bid,a.CBid">
<CFSET LvarDesplegar ="Bdescripcion, CBdescripcion, ECdescripcion, EChasta"> 
<cfset LvarColumnas = "a.ECid, b.Bdescripcion, a.EChasta,
	                      case a.ECStatus when 1 then'Revisado'  when 0 then 'En Revision' end as ECStatus,
                         a.ECdesde, c.CBdescripcion, a.ECdescripcion, a.Bid">
                         
  <cfif isdefined("LvarTCEListaStadosCuenta")>

    <cf_dbfunction name="date_part"	args="YYYY, EChasta"  returnvariable="LvarPeriodo">
    <cf_dbfunction name="date_part"	args="mm, EChasta"    returnvariable="LvarMes">

 	<cfset LvarIrAEC="EstadosCuentaTCE.cfm">
    <cfset LvarEtiqueta ="Banco, Tarjeta Crédito, Estatus, Periodo, Mes, Estado Pago"> 
	<cfset LvarIrARPregistrMasive="../Reportes/RPRegistroEstadosCtasMasivoTCE.cfm">
	<cfset LvarIrARPRegisMovBanc="../Reportes/RPRegistroMovBancariosTCE.cfm">
	<cfset title1="Registro de Estados de Cuenta TCE">
	<cfset title2="Lista de Estados de Cuenta TCE">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
    <cfset LvarFormatos ="S,S,S,IS,IS,US"> 
    <CFSET LvarAlign ="left,left,left,left,left,left,left"> 
    <cfset LvarFiltrar  ="b.Bid, c.CBid, a.ECStatus, EChasta, EChasta,CBPTCestatus"> 
    <cfset LvarDesplegar ="Bdescripcion, CBdescripcion, ECStatus,Periodo,Mes, CBPTCestatus"> 
    <cfset LvarColumnas  = "a.ECid, b.Bdescripcion, #LvarPeriodo#  as Periodo,#LvarMes# as Mes,
	                       case a.ECStatus when 1 then'Revisado'  when 0 then 'En Revision' end as ECStatus,
						   a.ECdesde, c.CBdescripcion, a.ECdescripcion, a.Bid,
						   coalesce((select case e.CBPTCestatus  
						                        when 10 then'En Digitación'  
						                        when 11 then 'En Proceso' 
												when 12 then 'Emitido' 
												when 13 then 'Anulado' 												 
												end
							 from CBEPagoTCE e inner join CBDPagoTCEdetalle d
						   on e.CBPTCid = d.CBPTCid
						  where
						   d.ECid = a.ECid
						    and not exists (select 1 from CBEPagoTCE g where CBPTCidOri= e.CBPTCid)
						   ), 'Sin pago registrado') as CBPTCestatus">   
	<cfset LvarCondiciones="">
    
    <cfif isdefined ('form.FILTRO_BDESCRIPCION') and len(trim(#form.FILTRO_BDESCRIPCION#)) gt 0>
        <cfset LvarCondiciones = LvarCondiciones &' and b.Bid ='& #form.FILTRO_BDESCRIPCION#>
    </cfif>
    <cfif isdefined ('form.FILTRO_CBDESCRIPCION') and len(trim(#form.FILTRO_CBDESCRIPCION#)) gt 0>
        <cfset LvarCondiciones = LvarCondiciones &' and c.CBid ='& #form.FILTRO_CBDESCRIPCION#>
    </cfif>
    <cfif isdefined ('form.FILTRO_ECSTATUS') and len(trim(#form.FILTRO_ECSTATUS#)) gt 0>
        <cfset LvarCondiciones = LvarCondiciones &' and a.ECStatus ='& #form.FILTRO_ECSTATUS#>
    </cfif>
    <cfif isdefined ('form.FILTRO_MES') and len(trim(#form.FILTRO_MES#)) gt 0>
       <cfset LvarCondiciones = LvarCondiciones &' and #LvarMes# = '& #form.FILTRO_MES#>
    </cfif>
    <cfif isdefined ('form.FILTRO_PERIODO') and len(trim(#form.FILTRO_PERIODO#)) gt 0>
        <cfset LvarCondiciones = LvarCondiciones &' and #LvarPeriodo# ='& #form.FILTRO_PERIODO#>
    </cfif>        
        <CFSET lvarFiltro= "b.Ecodigo = #Session.Ecodigo#
                      and c.CBesTCE = #LvarCBesTCE#
                      and a.Bid = b.Bid 
                      and a.CBid = c.CBid 
                      and a.EChistorico = 'N'
                      and a.ECaplicado = 'N'
                      #PreserveSingleQuotes(LvarCondiciones)#
                      order by a.Bid,a.CBid">                           

 </cfif>
 
 
<cf_navegacion name="PageNum_lista" default="" session>
<cfif isdefined("Url.Fecha") and not isdefined("form.Fecha")>
	<cfset form.Fecha = Url.Fecha>
</cfif>
<cfif isdefined("Url.Banco") and not isdefined("form.Banco")>
	<cfset form.Banco = Url.Banco>
</cfif>
<cfif isdefined("Url.Cuenta") and not isdefined("form.Cuenta")>
	<cfset form.Cuenta = Url.Cuenta>
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("form.Usuario")>
	<cfset form.Usuario = Url.Usuario>
</cfif>
<cfif isdefined("Url.Documento") and not isdefined("form.Documento")>
	<cfset form.Documento = Url.Documento>
</cfif>
<cfquery name="rsBancos" datasource="#Session.dsn#">
	<cfif isdefined("LvarTCEListaStadosCuenta")>
                    select 
                        '' as value, '-- Todos --' as description from dual	union all	
                    select distinct
                        <cf_dbfunction name="to_char"	args="b.Bid"> as value, 
                        b.Bdescripcion as description 
                    from ECuentaBancaria a 
                        inner join Bancos b
                            on a.Bid = b.Bid 
                        inner join CuentasBancos c
                            on c.CBid = a.CBid
                    where 	
                            c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                        and c.CBesTCE = 1
                        and a.CBid = c.CBid 
                <cfelse>
                    select '' as value, '-- Todos --' as description from dual
                    union all
                    select <cf_dbfunction name="to_char"	args="Bid"> as value, Bdescripcion as description
                    from Bancos
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                </cfif>
</cfquery>
<cfquery name="rsCuentasBancos" datasource="#Session.dsn#">       
     	<cfif isdefined("LvarTCEstadosCuentaProceso")>
            select '' as value, '-- Todos --' as description,'' as Bid from dual
            union all
            select <cf_dbfunction name="to_char" args="c.CBid" > as value, CBdescripcion as description, <cf_dbfunction name="to_char"	args="b.Bid" >
            from ECuentaBancaria a 
                inner join Bancos b
                    on a.Bid = b.Bid 
                inner join CuentasBancos c
                    on c.CBid = a.CBid
            where 	
                    c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and c.CBesTCE = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarCBesTCE#">
                and a.CBid = c.CBid
                and a.EChistorico = <cfqueryparam cfsqltype="cf_sql_char" value="N">
                and a.ECStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        <cfelse>
            select '' as value, '-- Todos --' as description, '' as Bid from dual
            union all
            select <cf_dbfunction name="to_char"	args="CBid" > as value, CBdescripcion as description, <cf_dbfunction name="to_char"	args="Bid" >
            from CuentasBancos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and CBesTCE = #LvarCBesTCE#
       </cfif>
</cfquery>		   	
<cfquery name="rsEstado" datasource="#session.DSN#">
	select '' as value, '-- Todos --' as description from dual
	union
	select 'S' as value, 'LISTO' as description from dual
	union
	select 'N' as value, 'EN PROCESO' as description from dual
	order by value
</cfquery>
<cfquery name="rsECStatus" datasource="#session.DSN#">
	select null as value, '-- Todos --' as description from dual
	union
	select 1 as value, 'Revisado' as description from dual
	union
	select 0 as value, 'En Revision' as description from dual
	order by value
</cfquery>
<cf_templateheader title="#title1#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#title2#'>
		<cfinclude template="../../portlets/pNavegacionMB.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td>
                    	<cfset botones = "Nuevo,Imprimir">
                    	<cfif isdefined("LvarTCEListaStadosCuenta")>
                        	<cfset botones = "Nuevo,Imprimir,Revisado">
                        </cfif>
						<form style="margin: 0"  name="filtros" action="<cfoutput>#LvarIrAEC#</cfoutput>" method="post">							
							<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet">
								<cfinvokeargument name="columnas"  				value="#LvarColumnas#"/>                                                                                           
								<cfinvokeargument name="tabla"  				value="ECuentaBancaria a, Bancos b, CuentasBancos c"/>
								<cfinvokeargument name="filtro"  				value="#lvarFiltro#"/>
								<cfinvokeargument name="desplegar"  			value="#LvarDesplegar#"/>
								<cfinvokeargument name="filtrar_por"  			value="#LvarFiltrar#"/>  
								<cfinvokeargument name="etiquetas"  			value="#LvarEtiqueta#"/>
								<cfinvokeargument name="formatos"   			value="#LvarFormatos#"/>
								<cfinvokeargument name="align"      			value="#LvarAlign#"/>
								<cfinvokeargument name="ajustar"    			value="N"/>		
								<cfinvokeargument name="irA"        			value="#LvarIrAEC#"/>								
								<cfinvokeargument name="showLink" 				value="true"/>
								<cfinvokeargument name="checkboxes" 	 	 	value="S"/>		
								<cfinvokeargument name="botones"    			value="#botones#"/>
								<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
								<cfinvokeargument name="maxrows" 				value="15"/>
								<cfinvokeargument name="keys"             		value="ECid"/>
								<cfinvokeargument name="mostrar_filtro"			value="true"/>
								<cfinvokeargument name="filtrar_automatico"		value="false"/>                           
								<cfinvokeargument name="formname"				value="filtros"/>
								<cfinvokeargument name="incluyeform"			value="false"/>
								<cfinvokeargument name="rsBdescripcion"			value="#rsBancos#"/>
								<cfinvokeargument name="rsCBdescripcion"		value="#rsCuentasBancos#"/>
                                <cfinvokeargument name="rsECStatus"		value="#rsECStatus#"/>
							</cfinvoke>
							<input name="marcados" type="hidden" value="">
                            <input name="Revisar"  type="hidden" value="">
						</form>
					</td>
				</tr>
			</table> 
	<cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms form="filtros">
<script>
	objForm.filtro_Bdescripcion.addEvent('onChange', 'llenarCuentasBancarias(this.value);', true);
	function llenarCuentasBancarias(v){
		var combo = objForm.filtro_CBdescripcion.obj;
		var cont = 1;
		//combo.length=0;
		combo.length = 1;
		combo.options[0].text = '---Todas---';
		combo.options[0].value = '';
		<cfoutput query="rsCuentasBancos">
			if (#rsCuentasBancos.Bid#==v)
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsCuentasBancos.value#';
				combo.options[cont].text='#rsCuentasBancos.description#';
				<cfif isdefined("form.filtro_CBdescripcion") and len(trim(form.filtro_CBdescripcion))>
					if (#form.filtro_CBdescripcion#==#rsCuentasBancos.value#) combo.options[cont].selected = true;
				</cfif>
				cont++;
			};
		</cfoutput>
	}
	llenarCuentasBancarias(objForm.filtro_Bdescripcion.getValue());
</script>
						           	
<script language="JavaScript1.2" type="text/javascript">
	function funcNuevo(){
		<!---Redireccion EstadosCuenta.cfm o TCEEstadosCuenta.cfm (Tarjetas de Credito)--->							
		document.filtros.action="<cfoutput>#LvarIrAEC#</cfoutput>";
	}
	
	// ============================================================================		
	// Llama a la pantalla del reporte
	// ============================================================================		
	var popUpWin=0;
	function popUpWindowReporte(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	function Imprimir(EMid){
		<!---RPRegistroMovBancarios.cfm o TCERPRegistroMovBancarios.cfm--->
  		var PARAM  = "<cfoutput>#LvarIrARPRegisMovBanc#</cfoutput>?EMid="+EMid; 
		popUpWindowReporte(PARAM,75,50,850,630);
		//open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400');
	}
	function funcImprimir(){
		funcMarca(document.filtros.chkAllItems);
		if ( document.filtros.marcados.value.length > 0 ){
			<cfoutput>
			<!---RPRegistroEstadosCtasMasivo.cfm o TCERPRegistroEstadosCtasMasivo.cfm--->
			var PARAM  = "<cfoutput>#LvarIrARPregistrMasive#</cfoutput>?lista="+document.filtros.marcados.value; 
			open(PARAM,'','left=100,top=100,scrollbars=yes,resizable=yes,width=800,height=600');
			</cfoutput>
			document.filtros.marcados.value='';
			return false;
		}else{
			alert('Debe seleccionar al menos un Estado de Cuenta para ser Revisado.');
			return false;
		}
	}
	function funcRevisado(){
		funcMarca(document.filtros.chkAllItems);
		if (document.filtros.marcados.value.length > 0 ){
			document.filtros.Revisar.value = "Revisar";
			document.filtros.action="SQLEstadosCuentaTCE.cfm";
			document.filtros.submit(0);
			document.filtros.marcados.value='';
			return false;
		}else{
			alert('Debe seleccionar al menos un Estado de Cuenta.');
			return false;
		}
	}
	function funcMarca(){
	var f = document.filtros;
	if (f.chk != null) {
		if (f.chk.value) {
		
			if (f.chk.checked) {
				f.marcados.value = f.marcados.value + ',' + f.chk.value;
			}
		} else {
			for (var i=0; i<f.chk.length; i++) {
				if (f.chk[i].checked) {
					if (f.length==0)
						f.marcados.value =  f.chk[i].value;
					else
						f.marcados.value = f.marcados.value + ',' + f.chk[i].value;
				}
			}
		}
	}
}
</script>