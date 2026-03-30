<style>
	.lista{
	width:100%;
	border:3px double #f2f2f2;
	margin:15px 2px;
}
.lista tr{
	height:20px;
}

.lista tr.estatico{
	background:#f2f2f2;
}

.lista th,
.lista td,
.lista td a{	
	font-size:13px;	
	vertical-align:top;
}

.lista td a{
	color:#FFCC00;	
}

.lista td:hover{
	color:#0F0;
}

.lista th{
	background:url(http://www.frogx3.com/ejemplos/images/text-bg.gif) #ffffff repeat-x;
	border-bottom:3px double #f2f2f2;
	line-height:20px;
	border-right:3px double #f2f2f2;
}

.lista td{
	border-right:1px solid #f2f2f2;	
	border-bottom:1px solid #f2f2f2;
	line-height:20px;	
}
</style>
<cfquery name="rsVariables" datasource="#session.dsn#">
select DRDNombre, AnexoCon, DRDNegativo, AVid, ANHCid, DRDValor, DRDMeses
	from DReportDinamic
 where ERDid  = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#form.ERDid#">
</cfquery>
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>
Listado de las Variables
<table border="0" width="100%" cellpadding="0" cellspacing="0" class="lista">
	<tr>
		<th >Nombre</th >
		<th >Concepto</th >
		<th >Homologación</th >
        <th >Negativo</th >
		<th >Meses</th >
		<th >Valor</th >
	</tr>
    <cfoutput>
    	<cfset cont =1>
    <cfloop query="rsVariables">
    <input type="hidden" id="DRDNombre_#cont#"  value="#rsVariables.DRDNombre#"/>
    <tr>
    	<td>#rsVariables.DRDNombre#</td>
		<td>
        <select id="AnexoCon_#cont#" name="" onchange="AnexoCon(this.value,listaHomo_#cont#,inputFormular_#cont#,listaAnexos_#cont#)">            
            <optgroup label="Textos">  
            	<option value="0" <cfif rsVariables.AnexoCon eq 0 >selected="selected" </cfif>>&nbsp;&nbsp;Moneda</option>
                <option value="1" <cfif rsVariables.AnexoCon eq 1 >selected="selected" </cfif>>&nbsp;&nbsp;Nombre Empresa</option>
                <option value="2" <cfif rsVariables.AnexoCon eq 2 >selected="selected" </cfif>>&nbsp;&nbsp;Nombre Oficina</option>
                <option value="4" <cfif rsVariables.AnexoCon eq 4 >selected="selected" </cfif>>&nbsp;&nbsp;Unidad Expresion</option>
                <option value="10" disabled="disabled" <cfif rsVariables.AnexoCon eq 10 >selected="selected" </cfif>>&nbsp;&nbsp;Mes: MM</option>
                <option value="11" disabled="disabled" <cfif rsVariables.AnexoCon eq 11 >selected="selected" </cfif>>&nbsp;&nbsp;Nombre Mes</option>
                <option value="12" <cfif rsVariables.AnexoCon eq 12 >selected="selected" </cfif>>&nbsp;&nbsp;Año: YYYY</option>
                <option value="13" disabled="disabled" <cfif rsVariables.AnexoCon eq 13 >selected="selected" </cfif>>&nbsp;&nbsp;Año Mes: MM/YYYY</option>
                <option value="14" disabled="disabled" <cfif rsVariables.AnexoCon eq 14 >selected="selected" </cfif>>&nbsp;&nbsp;Leyenda Fin Mes</option>
                <option value="15" disabled="disabled" <cfif rsVariables.AnexoCon eq 15 >selected="selected" </cfif>>&nbsp;&nbsp;Mes: MMM</option>
                <option value="16" disabled="disabled" <cfif rsVariables.AnexoCon eq 16 >selected="selected" </cfif>>&nbsp;&nbsp;Año Mes: MMM/YYYY</option>
                <option value="17" disabled="disabled" <cfif rsVariables.AnexoCon eq 17 >selected="selected" </cfif>>&nbsp;&nbsp;Año Mes: YYYY-MM</option>
                <option value="18" disabled="disabled" <cfif rsVariables.AnexoCon eq 18 >selected="selected" </cfif>>&nbsp;&nbsp;Inicio Per.Fin Mes</option>
            </optgroup>
            <optgroup label="Otros Datos">
                <option value="3"  disabled="disabled" <cfif rsVariables.AnexoCon eq 3 >selected="selected" </cfif>>&nbsp;&nbsp;Variables</option>
                <option value="63" <cfif rsVariables.AnexoCon eq 63 >selected="selected" </cfif>>&nbsp;&nbsp;Operaciones Ariméticas</option>
            </optgroup>
            <optgroup label="Saldos Contables">
                <option value="21" <cfif rsVariables.AnexoCon eq 21 >selected="selected" </cfif>>&nbsp;&nbsp;Saldo Inicial</option>
                <option value="22" disabled="disabled" <cfif rsVariables.AnexoCon eq 22 >selected="selected" </cfif>>&nbsp;&nbsp;Débitos Mes</option>
                <option value="23" disabled="disabled" <cfif rsVariables.AnexoCon eq 23 >selected="selected" </cfif>>&nbsp;&nbsp;Créditos Mes</option>
                <option value="24" disabled="disabled" <cfif rsVariables.AnexoCon eq 24 >selected="selected" </cfif>>&nbsp;&nbsp;Movimientos Mes</option>               
                <option value="20" <cfif rsVariables.AnexoCon eq 20 >selected="selected" </cfif>>&nbsp;&nbsp;Saldo Final</option>
                <option value="32" <cfif rsVariables.AnexoCon eq 32 >selected="selected" </cfif>>&nbsp;&nbsp;Débitos Acum.</option>
                <option value="33" disabled="disabled" <cfif rsVariables.AnexoCon eq 33 >selected="selected" </cfif>>&nbsp;&nbsp;Créditos Acum.</option>
                <option value="34" disabled="disabled" <cfif rsVariables.AnexoCon eq 34 >selected="selected" </cfif>>&nbsp;&nbsp;Movimientos Acum.</option>
            </optgroup>
            <optgroup label="Movimientos Bancarios">
                <option value="25" disabled="disabled" <cfif rsVariables.AnexoCon eq 25 >selected="selected" </cfif>>&nbsp;&nbsp;Flujo de Efectivo en el Mes</option>
            </optgroup>
            <optgroup label="Saldos Contables de Cierres">
                <option value="35" disabled="disabled" <cfif rsVariables.AnexoCon eq 35 >selected="selected" </cfif>>&nbsp;&nbsp;Saldo Inicial Cierre</option>
                <option value="36" disabled="disabled" <cfif rsVariables.AnexoCon eq 36 >selected="selected" </cfif>>&nbsp;&nbsp;Débitos Cierre</option>
                <option value="37" disabled="disabled" <cfif rsVariables.AnexoCon eq 37 >selected="selected" </cfif>>&nbsp;&nbsp;Créditos Cierre</option>
                <option value="38" disabled="disabled" <cfif rsVariables.AnexoCon eq 38 >selected="selected" </cfif>>&nbsp;&nbsp;Movimientos Cierre</option>
                <option value="39" disabled="disabled" <cfif rsVariables.AnexoCon eq 39 >selected="selected" </cfif>>&nbsp;&nbsp;Saldo Final Cierre</option>
            </optgroup>
            <optgroup label="Presupuesto Contable">
                <option value="40" disabled="disabled" <cfif rsVariables.AnexoCon eq 40 >selected="selected" </cfif>>&nbsp;&nbsp;Presupuesto Contable Ini.</option>
                <option value="41" disabled="disabled" <cfif rsVariables.AnexoCon eq 41 >selected="selected" </cfif>>&nbsp;&nbsp;Presupuesto Contable Mes</option>
                <option value="42" disabled="disabled" <cfif rsVariables.AnexoCon eq 42 >selected="selected" </cfif>>&nbsp;&nbsp;Presupuesto Contable Fin.</option>
            </optgroup>
            <optgroup label="Saldos de Control de Presupuesto">
                <option value="50" disabled="disabled" <cfif rsVariables.AnexoCon eq 50 >selected="selected" </cfif>>&nbsp;&nbsp;Control Presupuesto Mes</option>
                <option value="51" disabled="disabled" <cfif rsVariables.AnexoCon eq 51 >selected="selected" </cfif>>&nbsp;&nbsp;Control Presupuesto Acum</option>
                <option value="52" disabled="disabled" <cfif rsVariables.AnexoCon eq 52 >selected="selected" </cfif>>&nbsp;&nbsp;Control Presupuesto Per.</option>
            </optgroup>
            <optgroup label="Formulación de Presupuesto">
                <option value="60" disabled="disabled" <cfif rsVariables.AnexoCon eq 60 >selected="selected" </cfif>>&nbsp;&nbsp;Formulación Presup. Mes</option>
                <option value="61" disabled="disabled" <cfif rsVariables.AnexoCon eq 61 >selected="selected" </cfif>>&nbsp;&nbsp;Formulación Presup. Acum</option>
                <option value="62" disabled="disabled" <cfif rsVariables.AnexoCon eq 62 >selected="selected" </cfif>>&nbsp;&nbsp;Formulación Presup. Per.</option>
            </optgroup>
        </select> 
		<td valign="top" width="400" align="left">

        <div id="listaHomo_#cont#" <cfif rsVariables.AnexoCon EQ 63 OR  rsVariables.AnexoCon LT 18> style="visibility:hidden;height:0px;"  </cfif>>
			<cfif len(trim(rsVariables.ANHCid))gt 0 and rsVariables.AnexoCon NEQ 63 and  rsVariables.AnexoCon GT 18 >
			<div style="float:left">
                <cf_conlis name="conlis_ANHCid"
                columnas	="Ah.ANHid as ANHid_#cont#,Ah.ANHcodigo as ANHcodigo_#cont#,Ah.ANHdescripcion as ANHdescripcion_#cont#,ACta.ANHCid as ANHCid_#cont#,ACta.ANHCcodigo as ANHCcodigo_#cont#,ACta.ANHCdescripcion as ANHCdescripcion_#cont#"
                tabla		="ANhomologacion Ah 
                                inner join ANhomologacionCta ACta
                                    on ACta.ANHid = Ah.ANHid"
                campos		="ANHid_#cont#,ANHcodigo_#cont#,ANHdescripcion_#cont#,ANHCid_#cont#,ANHCcodigo_#cont#,ANHCdescripcion_#cont#"
                Cortes		="ANHdescripcion_#cont#"
                traerInicial 	="true"
                MAXCONLISES = "50"
                traerFiltro 	="ANHCid = #rsVariables.ANHCid#"
                desplegables	= "N, N, N,N, S, S"
                desplegar		= "ANHCid_#cont#,ANHCcodigo_#cont#,ANHCdescripcion_#cont#"
                etiquetas		= "Código, Descripci&oacute;n" 
                funcion		="ChangeHomologacion(ANHCid_#cont#,'#rsVariables.DRDNombre#',#form.ERDid#)" 
                >
     		</div>	
                <cfquery name="rsExisteANHCid" datasource="#session.dsn#">
                    select *
                        from ANhomologacionFmts f
                            inner join ANhomologacionCta c
                             on c.ANHCid = f.ANHCid
                        where c.ANHCid = #rsVariables.ANHCid#
                </cfquery>	
           	<div style="float:left">
                <cfif rsExisteANHCid.recordcount gt 0>
                    <img src="/sif/imagenes/configurada.png"  onclick="ModificarVarhomologa(ANHCid_#cont#.value,ANHid_#cont#.value)" width="25" height="25" style="cursor:pointer"  alt="Formular" />
                <cfelse>    
                    <img src="/sif/imagenes/sinconfigura.png"   onclick="ModificarVarhomologa(ANHCid_#cont#.value,ANHid_#cont#.value)" width="25" height="25" style="cursor:pointer"  alt="Formular" />
                </cfif>
          	</div>
           <cfelse>
          	<div style="float:left">
                <cf_conlis 
                columnas	="Ah.ANHid as ANHid_#cont#,Ah.ANHcodigo as ANHcodigo_#cont#,Ah.ANHdescripcion as ANHdescripcion_#cont#,ACta.ANHCid as ANHCid_#cont#,ACta.ANHCcodigo as ANHCcodigo_#cont#,ACta.ANHCdescripcion as ANHCdescripcion_#cont#"
                tabla		="ANhomologacion Ah 
                                inner join ANhomologacionCta ACta
                                    on ACta.ANHid = Ah.ANHid"
                campos		="ANHid_#cont#,ANHcodigo_#cont#,ANHdescripcion_#cont#,ANHCid_#cont#,ANHCcodigo_#cont#,ANHCdescripcion_#cont#"
                Cortes		="ANHdescripcion_#cont#"
                MAXCONLISES = "50"
                desplegables	= "N, N, N,N, S, S"
                desplegar		= "ANHCcodigo_#cont#, ANHCdescripcion_#cont#"
                etiquetas		= "Código, Descripci&oacute;n"
                funcion		="ChangeHomologacion(ANHCid_#cont#,'#rsVariables.DRDNombre#',#form.ERDid#)" 
                >
	        </div>
          	<div style="float:left">
             	<img src="../../imagenes/sinconfigura.png"   onclick="ModificarVarhomologa(ANHCid_#cont#.value,ANHid_#cont#.value)" width="25" height="25" style="cursor:pointer"  alt="Formular" />
           	</div>
           </cfif>
      		<!---<input type="button" onclick="ModificarVarhomologa(ANHCid_#cont#.value,ANHid_#cont#.value)" name="Modificar" id="Modificar" value="Modificar" />--->	 
       </div>
       <div id="listaAnexos_#cont#"  <cfif rsVariables.AnexoCon NEQ 3> style="visibility:hidden;height:0px;"</cfif>>
			<cfif len(trim(rsVariables.ANHCid))gt 0 and rsVariables.AnexoCon EQ 3>
                <cf_conlis 
                columnas	="AVid as AVI_#cont#, AVnombre as AVnombre_#cont#"
                tabla		="AnexoVar"
               	campos		="AVI_#cont#, AVnombre_#cont#"
                traerInicial 	="true"
                MAXCONLISES = "50"
                traerFiltro 	="AVid = #rsVariables.ANHCid#"
                desplegables	= "S, S"
                desplegar		= "AVI_#cont#, AVnombre_#cont#"
                etiquetas		= "Código, Descripci&oacute;n" 
                funcion		="ChangeHomologacion(AVI_#cont#,'#rsVariables.DRDNombre#',#form.ERDid#)" 
                >
           <cfelse>
                <cf_conlis 
                columnas	="AVid as AVI_#cont#, AVnombre as AVnombre_#cont#"
                tabla		="AnexoVar"
                MAXCONLISES = "50"
               	campos		="AVI_#cont#, AVnombre_#cont#"
                desplegables	= "S, S"
                desplegar		= "AVI_#cont#, AVnombre_#cont#"
                etiquetas		= "Código, Descripci&oacute;n"
                funcion		="ChangeHomologacion(AVI_#cont#,'#rsVariables.DRDNombre#',#form.ERDid#)" 
                >
           </cfif>
       </div>
   	   <div id="inputFormular_#cont#" <cfif rsVariables.AnexoCon neq 63> style="visibility:hidden; height:0px;" </cfif>>
       	<cfif rsVariables.AnexoCon eq 63  and len(trim(rsVariables.DRDValor)) gt 0>
        	<img src="../../imagenes/formular_2.png"  onclick="CrearFormulacion('#rsVariables.DRDNombre#')" width="25" height="25" style="cursor:pointer"  alt="Formular" />
        <cfelse>    
       		<img src="../../imagenes/formular.png"  onclick="CrearFormulacion('#rsVariables.DRDNombre#')" width="25" height="25" style="cursor:pointer"  alt="Formular" />
       	</cfif>
       </div>
        </td>
       <td ><input type="checkbox"  name="DRDNegativo_#cont#"  id="DRDNegativo_#cont#" onclick="if(this.value==1){this.value=0}else{this.value=1}" <cfif rsVariables.DRDNegativo eq 1>checked="checked" value="1" <cfelse> value="0"</cfif>/></td>
		<td><input type="text" name="DRDMeses_#cont#" 	id="DRDMeses_#cont#" value="#rsVariables.DRDMeses#" size="10" /></td>
		<td><input type="text" name="AVid_#cont#" 		id="AVid_#cont#" 	value="#rsVariables.AVid#"  size="10" /></td>
    </tr>
    	
  <cfdiv bind="url:/cfmx/sif/admin/ReportDinamic/ReportDinamic-sql.cfm?AnexoCon={AnexoCon_#cont#}&DRDNegativo={DRDNegativo_#cont#}&AVid={AVid_#cont#}&DRDNombre={DRDNombre_#cont#}&ERDid={ERDid}&DRDMeses={DRDMeses_#cont#}"
   bindOnLoad="false" 
   ID="theDivDEemail"/>
   			<cfset cont = cont + 1>
    </cfloop>
    </cfoutput>
</table>
<cf_Lightbox link="" titulo="Modificar Variables" width="80" height="80" name="modificarVar" url="/cfmx/sif/admin/ReportDinamic/modificaHomologacion.cfm"></cf_Lightbox>
<cf_Lightbox link="" titulo="Formular Variables" width="80" height="80" name="Formular" url="/cfmx/sif/admin/ReportDinamic/formuladoraVariables.cfm"></cf_Lightbox>
<iframe frameborder="0" name="fr" height="100" width="100" src=""></iframe>
<script language="javascript" >
	function ChangeHomologacion(ANHCid,DRDNombre,ERDid){
		document.all["fr"].src="/cfmx/sif/admin/ReportDinamic/ReportDinamic-sql.cfm?ANHCid="+ANHCid+"&ERDid="+ERDid+"&DRDNombre="+DRDNombre;	
	}
	function CrearFormulacion(DRDNombre){
		fnLightBoxSetURL_Formular("/cfmx/sif/admin/ReportDinamic/formuladoraVariables.cfm?ERDid=<cfoutput>#form.ERDid#</cfoutput>&DRDNombre="+DRDNombre);
		fnLightBoxOpen_Formular();
	}
	function ModificarVarhomologa(ANHCid,ANHid){
		if(ANHid==""){alert("Es necesario genarar las variables para poder configurarlas.")}
		else{
		fnLightBoxSetURL_modificarVar("/cfmx/sif/admin/ReportDinamic/modificaHomologacion.cfm?ERDid=<cfoutput>#form.ERDid#</cfoutput>&ANHCid="+ANHCid+"&ANHid="+ANHid);
		fnLightBoxOpen_modificarVar();}
	}
	function AnexoCon(id, listahomo, inputFormular , listaAnexos){
		if(id==63){
	  		listahomo.style.visibility="hidden";
			listahomo.style.height="0px";	
			listaAnexos.style.visibility="hidden";
			listaAnexos.style.height="0px";
			inputFormular.style.visibility="";
			inputFormular.style.height="20px";
		}<!---1 a 18 se esconden todo excepto el 3 que es formulacion--->
		else if(id<19 && id !=3){
			listahomo.style.visibility="hidden";
			listahomo.style.height="0px";
			inputFormular.style.visibility="hidden";
			inputFormular.style.height="0px";
			listaAnexos.style.visibility="hidden";
			listaAnexos.style.height="0px";
		}<!---Si es mayor a 18 es Homologacion a excepcion del 63 que arriba esta--->	
		else if(id>18 && id !=3){
			inputFormular.style.visibility="hidden";
			inputFormular.style.height="0px";	
			listahomo.style.visibility="";
			listahomo.style.height="20px";	
			listaAnexos.style.visibility="hidden";
			listaAnexos.style.height="0px";
		}
		else if(id==3){	
			listaAnexos.style.visibility="";
			listaAnexos.style.height="20px";
			inputFormular.style.visibility="hidden";
			inputFormular.style.height="0px";
			listahomo.style.visibility="hidden";
			listahomo.style.height="0px";	
		}
	}
	
</script>