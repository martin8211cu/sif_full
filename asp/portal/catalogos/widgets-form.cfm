
<cfset lvarWidID="0">
<cfset modo = "ALTA">
<cfif isdefined('url.WidID') and len(url.WidID) GT 0 >
	<cfset lvarWidID="#url.WidID#">
  <cfset modo = "CAMBIO">
</cfif>

<!--- Datos de la pagina --->
<cfquery name="rsSistemas" datasource="asp">
	select SScodigo, SSdescripcion
	from SSistemas
	order by SScodigo
</cfquery>

<cfquery name="rsModulos" datasource="asp">
	select SScodigo, SMcodigo, SMdescripcion
	from SModulos
	order by SMdescripcion
</cfquery>

<cfquery name="rsMenues" datasource="asp">
	select SScodigo, SMcodigo, SMNcodigo, <!---replicate(' ', SMNnivel*2) || SMNtitulo --->SMNtitulo
	from SMenues
	where SPcodigo is null
	order by SScodigo, SMcodigo, SMNpath, SMNorden
</cfquery>

<cfquery name="rsPos" datasource="asp">
	select WIDPosCodigo as WidPosicion,WIDPosDescripcion
  from WidgetPosicion
  order by WIDPosCodigo
</cfquery>

<cfif modo neq "ALTA">
  <cfquery name="rsWidget" datasource="asp">
    select * 
    from Widget
    where WidID = #lvarWidID#
  </cfquery>
</cfif>

<cfoutput>  
<form id="frmWidget" name="frmWidget" action="widgets-sql.cfm" method="post">
	<input type="hidden"  value = "<cfif modo neq "ALTA">#lvarWidID#</cfif>" name="hdWidID" id="hdWidID">
	<input type="hidden" value = "#modo#" name="modo" id="modo">
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popSistema" class="ui-hidden-accessible">Sistema:</label>
    </div>
    <div class="col-sm-8" align="left">
      <select id="popSistema" name="popSistema">
          <option value="">Todos</option>
          <cfloop query="rsSistemas">
            <option value="#trim(rsSistemas.SScodigo)#"  <cfif modo neq "ALTA"><cfif trim(rsWidget.SScodigo) EQ trim(rsSistemas.SScodigo)>selected</cfif></cfif>>
                #trim(rsSistemas.SScodigo)#
            </option>
          </cfloop>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popModulo" class="ui-hidden-accessible">M&oacute;dulo:</label>
    </div>
    <div class="col-sm-8" align="left">
      <select id="popModulo" name="popModulo">
        <option value="">Todos</option>
        <cfloop query="rsModulos">
          <option value="#trim(rsModulos.SMcodigo)#" <cfif modo neq "ALTA"><cfif trim(rsWidget.SMcodigo) EQ trim(rsModulos.SMcodigo)>selected</cfif></cfif>>
            #rsModulos.SMdescripcion#
          </option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popCodigo" class="ui-hidden-accessible">C&oacute;digo:</label>
    </div>
    <div class="col-sm-8" align="left">
      <input name="popCodigo" id="popCodigo" value="<cfif modo neq "ALTA">#rsWidget.WidCodigo#</cfif>" placeholder="C&oacute;digo Widget" data-theme="a" type="text" <cfif modo neq "ALTA">readonly</cfif> required>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popTitulo" class="ui-hidden-accessible">T&iacute;tulo:</label>
    </div>
    <div class="col-sm-8" align="left">
      <input name="popTitulo" id="popTitulo" value="<cfif modo neq "ALTA">#rsWidget.WidTitulo#</cfif>" placeholder="Titulo Widget" data-theme="a" type="text" required>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popDescrip" class="ui-hidden-accessible">Descripci&oacute;n:</label>
    </div>
    <div class="col-sm-8" align="left">
      <textarea name="popDescrip" id="popDescrip" placeholder="Descripcion Widget" style="min-width: 90%" rows="2" required><cfif modo neq "ALTA">#trim(rsWidget.WidDescripcion)#</cfif></textarea>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
    	<label for="popPosicion" class="ui-hidden-accessible">Posici&oacute;n:</label>
    </div>
    <div class="col-sm-8" align="left">
      <select id="popPosicion" name="popPosicion">
        <cfoutput>
         <cfloop query="rsPos">
          	<option value="#trim(rsPos.WidPosicion)#" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidPosicion) EQ trim(rsPos.WidPosicion)>selected</cfif></cfif>>
              #rsPos.WIDPosDescripcion#
            </option>
         </cfloop>
        </cfoutput>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popTamanio" class="ui-hidden-accessible">Tama&ntilde;o:</label>
    </div>
    <div class="col-sm-8" align="left">
      <select id="popTamanio" name="popTamanio">
        <option value="L" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidSize) EQ 'L'>selected</cfif></cfif>>Grande</option>
        <option value="M" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidSize) EQ 'M'>selected</cfif></cfif>>Mediano</option>
        <option value="S" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidSize) EQ 'S'>selected</cfif></cfif>>Peque&ntilde;o</option>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popTipo" class="ui-hidden-accessible">Tipo:</label>
    </div>
    <div class="col-sm-8" align="left">
      <select id="popTipo" name="popTipo">
        <option value="I" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidTipo) EQ 'I'>selected</cfif></cfif>>Indicador</option>
        <option value="C" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidTipo) EQ 'C'>selected</cfif></cfif>>Contenido</option>
      </select>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popMosTitulo" class="ui-hidden-accessible">Mostrar T&iacute;tulo:</label>
    </div>
    <div class="col-sm-8" align="left">
      <input type="checkbox" id="popMosTitulo" name="popMosTitulo" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidMostrarTitulo) EQ 'True'>checked</cfif><cfelse>checked</cfif>/>
    </div>
  </div>
  <div class="row">
	  <div class="col-sm-4" align="right">
      <label for="popMosOpcion" class="ui-hidden-accessible">Mostrar Opciones:</label>
    </div>
    <div class="col-sm-8" align="left">
      <input type="checkbox" id="popMosOpcion" name="popMosOpcion" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidMostrarOpciones) EQ 'True'>checked</cfif><cfelse>checked</cfif>/>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="chkSistema" class="ui-hidden-accessible">Widget del Sistema:</label> 
    </div>
    <div class="col-sm-8" align="left">
      <input type="checkbox" id="chkSistema" name="chkSistema" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidSistema) EQ 'True'>checked</cfif></cfif>/>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-4" align="right">
      <label for="popActivo" class="ui-hidden-accessible">Activo:</label> 
    </div>
    <div class="col-sm-8" align="left">
      <input type="checkbox" id="popActivo" name="popActivo" <cfif modo neq "ALTA"><cfif trim(rsWidget.WidActivo) EQ 'True'>checked</cfif><cfelse>checked</cfif>/>
    </div>
  </div>
  <cfif modo eq "ALTA">
    <div class="row">
      <div class="col-sm-4" align="right">
        <label for="popDev" class="ui-hidden-accessible">Creador:</label>
      </div>
      <div class="col-sm-8" align="left">
        <input name="popDev" id="popDev" placeholder="Nombre de Creador" data-theme="a" type="text" required>
      </div>
    </div>
  </cfif>
  <div class="row">
    <div class="col-sm-12" align="center">
      <cfif modo neq "ALTA">
        <cf_botones modo="CAMBIO" exclude="Nuevo,Baja">
      <cfelse>
        <cf_botones modo="ALTA">
      </cfif>
    </div>
  </div>
</form>
</cfoutput>

  
  <script type="text/javascript">
    

  </script>

  <script type="text/javascript">
    function change_sistema(obj){
      $('#popModulo')
          .find('option')
          .remove()
          .end()
          .append('<option value="">Todos</option>');
        <cfloop query="rsModulos">
          if ( arguments[0] == '<cfoutput>#trim(rsModulos.SScodigo)#</cfoutput>' ) {
          $('#popModulo').append('<option value=<cfoutput>#trim(rsModulos.SMcodigo)#</cfoutput>><cfoutput>#trim(rsModulos.SMdescripcion)#</cfoutput></option>')
            <cfif isdefined("rsWidget.SMcodigo") and trim(rsModulos.SMcodigo) eq trim(rsWidget.SMcodigo) >
                .val('<cfoutput>#trim(rsModulos.SMcodigo)#</cfoutput>')
              </cfif>
          ;
          }
        </cfloop>
    }


    var vSScodigo = '';
    <cfif isdefined("rsWidget.SScodigo")>
      vSScodigo = '<cfoutput>#trim(rsWidget.SScodigo)#</cfoutput>';
    </cfif>

    $('#popSistema').change(function() {
      change_sistema($(this).val());
    });
    change_sistema(vSScodigo);
    $("#frmWidget").validate();
  </script>
  

