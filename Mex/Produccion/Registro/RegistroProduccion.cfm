<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>


<!--- <cfdump var="#url.OTcodigo#"> --->
<!--- <cfdump var="#Form.OTcodigo#"> --->
 

<!--- <cf_templateheader title="SIF - Producción">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro Produccion'>
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm"> 
--->    
<!---    
    <cfquery name="rsOT" datasource="#Session.DSN#">
	select Ecodigo, OTcodigo, SNCodigo, OTdescripcion, OTfechaRegistro from Prod_OT
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric"> 
	order by OTcodigo
	</cfquery>
 --->
 
	
<cfif isdefined("form.OTcodigo")>
	<cfset OTSel = #form.OTcodigo#>	
</cfif>
<cfif isdefined('url.OT')>
	<cfset OTSel = #url.OT#>	
</cfif>
<cfif isdefined("form.OT")>
	<cfset OTSel = #form.OT#>	
</cfif>

<!---
	<cfset form.OTcodigo = url.OTcodigo>
	<cfset OTSel = url.OTcodigo>
    <cfset OTSel = form.OTcodigo>
</cfif>  

<cfset OTSel = #form.OTcodigo#>
 <cf_dump var="#OTSel#">  --->
     
    <cfif isdefined('form.OTcodigo') or isdefined('url.OT') or isdefined("form.OT")>
<!---		<cfset OTSel = #form.OTcodigo#>  --->
<!---		<cfdump var="#OTSel#">  --->

        <cfquery name="rsOT_Sel" datasource="#Session.DSN#">
          select p.Ecodigo, p.OTcodigo, p.SNCodigo, p.OTdescripcion, p.OTfechaRegistro, s.SNnombre
          from Prod_OT p
              inner join SNegocios s on
                  p.Ecodigo = s.Ecodigo
              and p.SNcodigo = s.SNcodigo
          where p.Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
              and p.OTcodigo=<cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
          order by p.OTcodigo
        </cfquery>
   
        <cfquery name="rsAreasP" datasource="#Session.DSN#">
            select pp.OTcodigo, pp.APcodigo, pp.OTseq, pa.APDescripcion, pa.Dcodigo, pa.Apinterno, pp.OTstatus
			from Prod_Proceso pp
				inner join Prod_Area pa on
					pp.Ecodigo = pa.Ecodigo
				and pp.APcodigo = pa.APcodigo
			where pp.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				and pp.OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
                and pa.Apinterno = 1
		    order by pp.OTseq
        </cfquery>
	</cfif>
    
    <cfif isdefined('url.AreaP') and isdefined('url.OTsec')>
    	<cfset AreaP = url.AreaP>
		<cfset OTsec = url.OTsec>
        <cfset OTsig = url.OTsec + 1>
		
 <!---       <cfdump var="aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii">       
        <cfdump var="#AreaP#">
        <cfdump var="#OTsec#">
        <cfdump var="#OTsig#"> --->
        
        <cfquery name="rsAreasPSig" datasource="#Session.DSN#"> 
        	select pp.OTcodigo, pp.APcodigo, pp.OTseq, pa.APDescripcion, pa.Dcodigo, pa.Apinterno, pp.OTstatus
			from Prod_Proceso pp
				inner join Prod_Area pa on
					pp.Ecodigo = pa.Ecodigo
				and pp.APcodigo = pa.APcodigo
			where pp.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and pp.OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
            and pp.OTseq > <cfqueryparam value="#OTsec#" cfsqltype="cf_sql_integer">
            order by pp.APcodigo
    	</cfquery>
        
        <cfquery name="rsSoloAreaSig" datasource="#Session.DSN#"> 
        	select pp.APcodigo, pa.APDescripcion, pp.OTseq
			from Prod_Proceso pp
				inner join Prod_Area pa on
					pp.Ecodigo = pa.Ecodigo
				and pp.APcodigo = pa.APcodigo
			where pp.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and pp.OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
            and pp.OTseq = <cfqueryparam value="#OTsig#" cfsqltype="cf_sql_integer">
            order by pp.APcodigo
    	</cfquery>
        
        <cfquery name="rsEstatusArea" datasource="#Session.DSN#">
        	select pp.OTstatus
			from Prod_Proceso pp
				inner join Prod_Area pa on
					pp.Ecodigo = pa.Ecodigo
				and pp.APcodigo = pa.APcodigo
			where pp.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and pp.OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
            and pp.OTseq = <cfqueryparam value="#OTsec#" cfsqltype="cf_sql_integer">
            order by pp.APcodigo
    	</cfquery>
        
        <cfquery name="rsMaximaAreaP" datasource="#Session.DSN#">
         select max(OTseq) as MaximaA from Prod_Proceso
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
    	</cfquery>

    </cfif>
    
    <cfif isdefined('url.ADestino')>
    	<cfset ADestino = url.ADestino>
        <cfquery name="rsBuscaDescAreaEspecifica" datasource="#Session.DSN#">        
            select pa.Apdescripcion
			from Prod_Proceso pp
				inner join Prod_Area pa on
					pp.Ecodigo = pa.Ecodigo
				and pp.APcodigo = pa.APcodigo
			where pp.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
			and pp.OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
            and pp.OTseq = <cfqueryparam value="#ADestino#" cfsqltype="cf_sql_integer">
	   	</cfquery>        
    </cfif>
    
	<cfset NumRegs_PInventario = 0>
    
    <cfif isdefined('url.AreaP') and isdefined('url.OTsec')> <!--- and isdefined('url.Espe')> --->
    	<cfset AreaP = url.AreaP>
		<cfset OTsec = url.OTsec>
   <!---     <cfset Espe = url.Espe> --->
   <!---		<cfdump var="Entre aqui">
        <cfdump var="#OTSel#">
        <cfdump var="#OTsec#"> 
        <cfdump var="Maxima">
        <cfdump var="#rsMaximaAreaP.MaximaA#">    --->
               
        <cfquery name="rsProdInventario" datasource="#Session.DSN#"> 
                select p.OTcodigo, p.OTseq, p.Artid, p.Pentrada, p.Psalida, p.Pexistencia, 
                        a.Adescripcion, u.Udescripcion
                from prod_Inventario as p
                    inner join Articulos as a on
                        p.Ecodigo = a.Ecodigo
                    and	p.Artid = a.Aid
                    inner join Unidades as u on
                        p.Ecodigo = u.Ecodigo
                    and	a.Ucodigo = u.Ucodigo
                where p.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
                    and p.OTcodigo = <cfqueryparam value="#OTSel#" cfsqltype="cf_sql_varchar">
                    and p.OTseq = <cfqueryparam value="#OTsec#" cfsqltype="cf_sql_integer"> 
                order by p.OTseq, p.Artid
    	</cfquery>
        <cfset NumRegs_PInventario = #rsProdInventario.recordcount#>
	</cfif>

<!--- Inicia la Forma --->
<form method="post" name="form1" action="SQLRegistroProduccion.cfm" onSubmit="javascript: return valida(this);">
<cfset RegistroProd = "MEDIO">
<!--- Tabla(1) --->
  
<input name="OT" type="hidden" id="OTcodigo" tabindex="1" value= "<cfoutput>#OTSel#</cfoutput>" onchange="document.location.href='RegistroProduccion.cfm?OT='+this.value;">

<TABLE WIDTH="100%" BORDER="0" align="top"> 
  <TR align="left">
    <!--- Presenta la Fecha de la OT --->
    <cfif isdefined('Form.OTcodigo') or isdefined('url.OT') or isdefined("form.OT")>
      <td align="left"><strong>Fecha :</strong></td>
      <td><input name="FechaOT" tabindex="1" type="text" value="<cfoutput>#rsOT_Sel.OTfechaRegistro#</cfoutput>" size="10" readonly></td>
      <td>&nbsp;  </td>
    <!--- Presenta al Cliente --->
      <td align="left"><strong>Cliente :</strong></td>
      <TD align="left"><cfoutput>#rsOT_Sel.SNnombre#</cfoutput></TD>
    <!--- </cfif>--->
  </TR>
  <tr align="left">
  	<td></td>
	<cfif isdefined('Form.OTcodigo') or isdefined('url.OT') or isdefined("form.OT")>
    	<td align="left" colspan="4"><b><cfoutput>#rsOT_Sel.OTdescripcion#</cfoutput></b></td>
  	</cfif>
  </tr>
</TABLE> <!--- Fin Tabla(1) --->

<HR SIZE=7 WIDTH="100%" COLOR="#0066CC" ALIGN = CENTER>

<!--- Inicio de la secuencia de los procesos por Area de Produccion --->
<!--- Tabla(3) --->
<table with="100%" border="0" cellpadding="1" cellspacing="1"> <!--- Tabla(3) primaria que contiene a tablas del Registro de Prod --->
  <tr>
      <td>
      
      
      
        <table border="2" height="350" width="100%"> <!--- Tabla(4) de Secuencia de Areas Prod. --->
            <cfif isdefined('Form.OTcodigo') or isdefined('url.OT') or isdefined("form.OT")>
            	<cfloop query="rsAreasP">
                
                  <cfif  isdefined('url.OTsec') and #OTsec# eq #rsAreasP.OTseq#>
                    <tr>
                      <td colspan="2" bgcolor="#FFFFFF">
                      <!--- Seleccion de Area --->
                      <cfoutput><b><a href="BuscaOTprod.cfm?AreaP=#rsAreasP.APDescripcion#&amp;OTsec=#rsAreasP.OTseq#&amp;OT=#rsAreasP.OTcodigo#" style="color: black;"   >#rsAreasP.APDescripcion#</a></b></cfoutput></td>
                    </tr>
                  <cfelse>
                  	<tr>
                    <td colspan="2" bgcolor="#0066CC">
                    <!--- Seleccion de Area --->
                    <cfoutput><b><a href="BuscaOTprod.cfm?AreaP=#rsAreasP.APDescripcion#&amp;OTsec=#rsAreasP.OTseq#&amp;OT=#rsAreasP.OTcodigo#" style="color: white;"   >#rsAreasP.APDescripcion#</a></b></cfoutput></td>
                    
         <!---            <td colspan="2"><cfoutput>#rsAreasP.APcodigo#</cfoutput></td>
                     <td colspan="2"><cfoutput>#rsAreasP.OTseq#</cfoutput></td>     --->
                  </tr>
                  </cfif>
                  
            	</cfloop>
            </cfif>
          <tr></tr>
        </table> <!--- Fin Tabla(4) ---> 
        
        
        
        
        
      </td>
	  <cfif isdefined('url.AreaP') and isdefined('url.OT')> <!--- Si Hay Area seleccionada y OT seleccionada --->
      <td> <!--- Inicia TD Principal de la Tabla de Traslado --->

        <TABLE border="0" height="300%" width="100%" align="center"> <!--- Inicio de Tabla(5) de traslado del material a siguiente Area --->
        
			<cfif isdefined('url.OTsec') and #Otsec# eq 0>
                    
              <tr><td><cfinclude template="DistribucionMaterialInsumo.cfm"></td></tr>
              
            <cfelse>
            
              <cfif isdefined('url.OTsec') and #Otsec# eq #rsMaximaAreaP.MaximaA#>
                   <input name="Registro" type="hidden" value="FINAL">
              <cfelse>
                   <input name="Registro" type="hidden" value="MEDIO">
              </cfif>
              
              <TR>
                <td> &nbsp &nbsp &nbsp </td>
                <cfif isdefined('url.AreaP') and isdefined('url.OT')>
                    <TD align="left"><font color="#CC0033"><cfoutput><b>#AreaP#</b></cfoutput></font></TD>
                <cfelse>
                    <td> &nbsp &nbsp &nbsp </td>
                </cfif>
    
                <td>&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;</td>
                <td><b>Status Area : </b></td>
                <td><b><font color="#CC0033"><cfoutput>#rsEstatusArea.OTstatus#</cfoutput></font></b></td> 
                <td>&nbsp;&nbsp;&nbsp;</td>
                <td><input type="checkbox" name="StatusInverso" id="StatusInverso" tabindex="1"></td>
          <!---      <cfdump var="#rsEstatusArea.OTstatus#">
               <cfdump var="#rsEstatusArea#"> --->
                
                <cfif trim(#rsEstatusArea.OTstatus#) eq "PROCESO"> 
                    <input name="Status" type="hidden" value="LIBERADA">
                    <TD><b><cfoutput>Liberar</cfoutput></b></TD> 
                <cfelse>
                    <input name="Status" type="hidden" value="PROCESO">
                    <TD><b><cfoutput>Reabrir</cfoutput></b></TD> 
                </cfif>
              </TR>
                <tr><td>&nbsp;  </td></tr>
              <TR> <!--- Opciones de Traslado --->
                <td> &nbsp &nbsp &nbsp </td>
                <TD align="center"><b>Trasladar a :</b></TD>
                <td><input type="radio" name="Traslado" value="<cfoutput> 1 </cfoutput>" id="Traslado1" checked onclick="Visible(this);">
                
                <!--- Hacia Area siguiente o subsecuente --->
                
                <cfif isdefined('url.AreaP') and isdefined('url.OTsec')> <!--- Si Hay Area seleccionada y Secuencia de Area seleccionada --->
                    <input name="AreaP" type="hidden" value="<cfoutput>#AreaP#</cfoutput>">
                    <input type="hidden" name="CodAreaAct" value="<cfoutput>#OTsec#</cfoutput>"/>
                    <input type="hidden" name="AreaPsig" value = "<cfoutput>#rsSoloAreaSig.OTseq#</cfoutput>" />
                    
                    <cfif isdefined('url.ADestino')> 
                      <label for="Traslado1"><cfoutput>#rsBuscaDescAreaEspecifica.Apdescripcion#</cfoutput></label>
                    <cfelse>
                      <label for="Traslado1"><cfoutput>#rsSoloAreaSig.APDescripcion#</cfoutput></label>
                    </cfif>
                </cfif>    
                </td>
              </TR>
                
              <tr>
                <td> &nbsp &nbsp &nbsp </td>
                <td></td>
                 <!--- Hacia Area que se desea especificar --->
                <td><input type="radio" name="Traslado" id="Traslado2" value="<cfoutput> 2 </cfoutput>" onclick="Visible(this);">
                                        <label for="Traslado2">Especificar :</label>
                </td>
                <td>
                    <!--- Presenta combo de Areas siguientes --->
                    <cfif isdefined('url.AreaP') and isdefined('url.OTsec')> <!--- Si Hay Area seleccionada y Secuencia de Area seleccionada --->
                      <select name="AreaSiguiente" id="OTseq" tabindex="1" disabled onchange="document.location.href='BuscaOTprod.cfm?ADestino='+this.value+'&OT='+document.form1.OT.value+'&OTsec='+document.form1.CodAreaAct.value+'&AreaP='+document.form1.AreaP.value;">
     
                      <cfoutput query="rsAreasPSig">
                        <cfif isdefined('url.ADestino')>
                          <option value="#rsAreasPSig.OTseq#" <cfif #rsAreasPSig.OTseq# EQ #ADestino#>selected</cfif>> #rsAreasPSig.APDescripcion# </option>
                        <cfelse>
                          <option value="#rsAreasPSig.OTseq#"> #rsAreasPSig.APDescripcion# </option>
                        </cfif>
                      </cfoutput>
                      </select>
                    </cfif>
                    <cfif isdefined('url.ADestino')>
                  <!---      <td><cfoutput>#ADestino#</cfoutput></td>  --->
                        <input name="AreaDestino" type="hidden" value="<cfoutput>#ADestino#</cfoutput>">
                    <cfelse>
                        <input name="AreaDestino" type="hidden" value="0">
                    </cfif>
                </td>
              </tr>
    
    	
    
              <tr> <!--- seleccion del Material --->
                <td> &nbsp &nbsp &nbsp </td>  
                <td align="left"><b>Envio de Material :</b></td>
              </tr>
                
              <TR> <!--- opcion enviar todo --->
                <td> &nbsp &nbsp &nbsp </td> 
                <td align="left"><input type="radio" name="EnvioM" value="<cfoutput> 1 </cfoutput>" id="EnvioM1"  checked onclick="VisibleEspeMat(this);">
                                      <label for="EnvioM1">Todo</label>
                </td>
              </TR>
    
              <tr> <!--- opcion enviar Material Especificado --->
                <td> &nbsp &nbsp &nbsp </td> 
                <td align="left"><input type="radio" name="EnvioM" value="<cfoutput> 2 </cfoutput>" id="EnvioM2" onclick="VisibleEspeMat(this);"> 
                                    <label for="EnvioM2">Especificar Material</label>
                </td>
              </tr>
    
              <cfif isdefined('url.AreaP') and isdefined('url.OT')> <!--- Si Hay Area seleccionada y OT seleccionada --->
                  <tr>
                      <td colspan="4">
           
                      <!--- Presenta Bloque Visible si se desea especificar el material --->
                      <div id="Especificar" style="display:inline">
                              <table width="100%" border="0"> <!--- Inicia Tabla(6) que presenta Articulos --->
                                  <tr>
                                      <td> &nbsp </td>
                                      <td width="25%"> &nbsp </td>
                                      <td><b>Entradas</b></td>
                                      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
                                      <td><b>Existencias</b></td>
                                      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
                                      <td><b>Salidas</b></td>
                                      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
                                      <td align="center"><b>Cantidad<br />por Trasladar</b></td>
                                      <td>&nbsp; &nbsp; &nbsp; &nbsp;</td>
                                      <td><b>U/M</b></td>
                                  </tr>
                                  
                                  <input type="hidden" name="NumRegs_PInventario" value="<cfoutput>#NumRegs_PInventario#</cfoutput>"/>
                               <cfoutput>   
                               <cfloop query="rsProdInventario">
                                 <TR>
                                    <td> &nbsp </td> 
                                    <TD>#rsProdInventario.Adescripcion#</TD>
                                    <td align="center"> 
                                        <input type="hidden" name="Artid" value="#rsProdInventario.Artid#" default="0"/>
                                    #rsProdInventario.Pentrada# </td>
                                    <td></td>
                                    <td align="center"> #rsProdInventario.Pexistencia# </td>
                                    <input type="hidden" name="Pexistencia" value="#rsProdInventario.Pexistencia#" default="0"/>
                                    <td></td>
                                    <td align="center"> #rsProdInventario.Psalida# </td>
                                    <td></td>
                                    <td><input name="CantTrasladar" tabindex="1" type="text" value=0 onblur="<cfoutput>javascript: return validaCantTras(this,#rsProdInventario.Pexistencia#)</cfoutput>"></td>
                                    	<input type="hidden" name="CantTrasladar2" value="Form.CantTrasladar" default="0"/>
                                    <td></td>
                                    <TD align="center">#rsProdInventario.Udescripcion#</TD>
                                </TR>
                               </cfloop> 
                               </cfoutput>
                              </table> <!--- fin Tabla(6) que presenta Articulos ---> 
                       </div> <!--- fin Presenta Bloque Visible material especificado --->
                       </td>                         
                  </tr>                 
               <cfelse>
                  <tr>
                      <td> &nbsp </td>
                  </tr> 
               </cfif>
     
            </cfif>
     	</TABLE> <!--- fin Tabla(5) Principal de Procesos de Prod. --->
        
      </td> <!--- fin TD Principal de la Tabla de Traslado --->
	  </cfif>
  </tr>
</table> <!--- fin tabla(3) primaria que contiene a tablas del Registro de Prod --->

<cfif isdefined('url.AreaP') and isdefined('url.OT')> <!--- Si Hay Area seleccionada y OT seleccionada --->
 <!--- Boton de Enviar y procesar traslado entre Areas de prod. --->
 <table with="100%" border="0" align="center">
  <tr>
  <td><strong><b><input type="submit" name="btnEnviar" value="Enviar"></b></strong></td>
  </tr>
 </table>
 <tr></tr>
</cfif>
</form>

</cfif>

<!--- ************************************************************* --->
<script language="JavaScript1.2" type="text/javascript">

function Visible(Activo){
	if (Activo.value == 1 ){
			document.form1.AreaSiguiente.disabled=true;
			document.form1.Traslado.checked=true;
		}
	
	if (Activo.value == 2 ){
			document.form1.AreaSiguiente.disabled=false;
			document.form1.Traslado.checked;
		}
	}

function funcVisualizar(){
		document.getElementById("Especificar").style.display='inline'; 
	}
	
function funcDesVisualizar(){
		document.getElementById("Especificar").style.display='none'; 
	}

function VisibleEspeMat(EMatSi){
		if (EMatSi.value == 2 ){
			funcVisualizar();
			}
		else{
			funcDesVisualizar();		
		}
	}
	
VisibleEspeMat(1);

	function validaCantTras(CantTrasladar,ExistP){
		var error = false;
		var CantT = 0;
		var CantT = parseInt(CantTrasladar.value)
		var mensaje = "Se presentaron los siguientes errores:\n";

		if (CantTrasladar.value == "" ){
			error = true;
			mensaje += "El campo Cantidad por Trasladar es requerido.\n";
		}
		
		if (CantT > ExistP){
			error = true;
			mensaje += "La Cantidad Solicitada no puede ser Mayor a la Existencia";
		} 

		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	  }


	function valida(formulario){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		var CantT = 0;
		var CantT = parseInt(CantTrasladar.value)		
		
		if (formulario.CantTrasladar.value == "" ){
			error = true;
			mensaje += " - El campo Cantidad a Trasladar es requerido.\n";
		}
		
		for (i=1;i<=<cfoutput>#NumRegs_PInventario#</cfoutput>;i++){
			if (parseInt(ListGetAt(formulario.CantTrasladar.value,i)) > parseInt(ListGetAt(formulario.Pexistencia.value,i))) {
				error = true;
				mensaje += "La Cantidad Solicitada no puede ser Mayor a la Existencia";
			}
		}
		

		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	}
    
</script>


