
<cfparam name="Attributes.query"    type="string"> <!--- String de la consulta a realizar (Utilizar savecontent para guardar el query)--->
<cfparam name="Attributes.columnas"    type="string"> <!---Columnas que se utilizaran de la consulta --->
<cfparam name="Attributes.nombreColumnasTabla"    type="string"> <!--- Cuales seran los nombres de la tabla que se muestre en el confirm --->
<cfparam name="Attributes.mostrar"    type="string"> <!--- Campos que se mostraran en la tabla (Usar S o N) (Aquello campos que no se muestren formaran se colocaran como hidden, lo que si seran un input normal) --->
<cfparam name="Attributes.idCampos"    type="string"> <!--- Id de los campos que se utilizaran en el form --->
<cfparam name="Attributes.columnasAFiltrar"    type="string" default=""> <!--- Columnas con las que se podra filtrar en la tabla --->
<cfparam name="Attributes.tipoColumnasAFiltrar" type="string" default=""> <!--- Indica el tipo en base de datos de la columnas se que van a filtrar (De momento solo funciona con char y varchar) --->
<cfparam name="Attributes.values"    type="string" default=""> <!---Valores que traen los campos inicialmente   --->
<cfparam name="Attributes.formato"    type="string"> <!--- Formato de las columnas (N for numeric, D for date, S for string) --->

<cfparam name="Attributes.tamanoInputs"    type="string"> <!--- Tamano del los inputs que se mostraran (se da en porcentaje, no deben superar el 100%--->

<cfparam name="Attributes.indice"    type="string" default="">
<!--- Indice para el conlisConfirm seleccionado --->

<cfparam name="Attributes.width"  		  default=""><!---Ancho del lightBox, esta dada en porcentaje, maximo valor 100--->
<cfparam name="Attributes.height" 		  default=""><!---Alto del lightBox, esta dada en porcentaje, maximo valor 100--->



<cfparam name="Attributes.title"       	  default=""> <!--- Titulo que llevara el confirm --->

<cfparam name="Attributes.Botones"    	  default="">  
<cfparam name="Attributes.Funciones"      default="PopUpCerrar">

<cfparam name="Attributes.ShowButtons" 	  default="" /> <!--- Si el valor es false, no se agregan los botones, en cualquier otro caso si se agregan --->
<cfparam name="Attributes.BlockModal" 	  default="" />
<cfparam name="Attributes.disable" default="N">   
<cfparam name="Attributes.label" default="">    
<!--- Label que se pondra antes de los inputs --->
<!--- Ejemplo de uso --->

<!--- <cf_conlisConfirm query="#queryFinal#"
                        columnas="CFid, CFcodigo,CFdescripcion,CFpath" 
                        nombreColumnasTabla= " , Codigo, Descripcion,  " 
                        mostrar="N,S,S,N" idCampos="cboCFid, cboCodigo, cboDescripcion,cboPath"
                        columnasAFiltrar="CFcodigo,CFdescripcion"
                        tipoColumnasAFiltrar="char,varchar"
                        formato =""
                        tamanoInputs="0,20,80,20"
                        botones="Cerrar"
                        ShowButtons="false"
                        importLibs="false"
                        width="70%" 
                        height = "70%">
--->


<!--- Se pasan las columnas a una lista --->
<cfset ArrayValues = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.values,',',true)#">
  <cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
  <cfset ArrayValues[LvarIdx] = trim(LvarEquivalencia[1])>
  
  <cfset LvarIdx = LvarIdx + 1>
</cfloop>

<!--- Se pasan las columnas a una lista --->
<cfset ArrayColumnas = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.columnas,',',true)#" >
	<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
	<cfset ArrayColumnas[LvarIdx] = trim(LvarEquivalencia[1])>
	
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>


<!--- Se pasan los campos que se mostrarar --->
<cfset ArrayMostrar = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.mostrar,',',true)#" >
	<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
	<cfset ArrayMostrar[LvarIdx] = trim(LvarEquivalencia[1])>
	
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>




<!--- Se pasan los Ids a una lista --->
<cfset ArrayIds = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.idCampos,',',true)#" >
	<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
	<cfset ArrayIds[LvarIdx] = trim(LvarEquivalencia[1])>
	
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>




<!--- Se extrae el tamano de los inputs --->
<cfset ArrayTamanoInputs = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.tamanoInputs,',',true)#" >
	<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
	<cfset ArrayTamanoInputs[LvarIdx] = trim(LvarEquivalencia[1])>
	
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>



<!--- Se pasan los Ids a una lista --->
<cfset ArrayFormato = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.formato,',',true)#" >
	<cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
	<cfset ArrayFormato[LvarIdx] = trim(LvarEquivalencia[1])>
	
	<cfset LvarIdx = LvarIdx + 1>
</cfloop>


<!--- Se recolectan las columnas que se mostraran en la tabla  --->
<cfset ArrayColumnasTabla = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop from="1" to="#ArrayLen(ArrayColumnas)#" index="i">

	<cfif ArrayMostrar[i] EQ 'S'>
		<cfset #ArrayAppend(ArrayColumnasTabla, "#ArrayColumnas[i]#")# >
	</cfif>
</cfloop>


<!--- Se pasan los Ids a una lista --->
<cfset ArrayNombreColumnasTabla = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.nombreColumnasTabla,',',true)#" >
  <cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
  <cfset ArrayNombreColumnasTabla[LvarIdx] = trim(LvarEquivalencia[1])>
  
  <cfset LvarIdx = LvarIdx + 1>
</cfloop>

<!--- Se pasan las columnas a filtrar a una lista --->
<cfset ArrayColumnasAFiltrar = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.columnasAFiltrar,',',true)#" >
  <cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
  <cfset ArrayColumnasAFiltrar[LvarIdx] = trim(LvarEquivalencia[1])>
  
  <cfset LvarIdx = LvarIdx + 1>
</cfloop>

<!--- Se pasan tipos de las columnas a filtrar Ids a una lista --->
<cfset ArrayTipoColumnasAFiltrar = arrayNew(1)>
<cfset LvarIdx = 1>
<cfset LvarFuncionTraerInicial = "">
<cfloop index="LvarCampoCol" array="#ListToArray(Attributes.tipoColumnasAFiltrar,',',true)#" >
  <cfset LvarEquivalencia = ListToArray("#LvarCampoCol#=*","=")>
  <cfif trim(LvarEquivalencia[1]) EQ '*'>
    <cfset LvarEquivalencia[1] = ''>
  </cfif>
  <cfset ArrayTipoColumnasAFiltrar[LvarIdx] = trim(LvarEquivalencia[1])>
  
  <cfset LvarIdx = LvarIdx + 1>
</cfloop>



<cfset ThisTag.Contenido        = ThisTag.GeneratedContent/>
    <cfset ThisTag.GeneratedContent = "" />
    
   
    <cfif not len(trim(attributes.Botones)) and not len(trim(attributes.ShowButtons))>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cerrar" xmlFile="/rh/generales.xml" default="Cerrar" returnvariable="LvarCerrar">
        <cfset attributes.Botones = LvarCerrar>
    </cfif>

<!-- Modal -->
  <div class="modal fade" id="myModal<cfoutput>#Attributes.indice#</cfoutput>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" <cfif len(trim(attributes.BlockModal))>data-backdrop="static" data-keyboard="false"</cfif>>
    <div class="modal-dialog" style='
    <cfif isdefined("attributes.height") and len(trim(attributes.height))> <cfoutput> height:#Attributes.height#%; </cfoutput> </cfif>
     <cfif isdefined("attributes.width") and len(trim(attributes.width))> <cfoutput> width:#Attributes.width#%;</cfoutput> </cfif>'>
      <div class="modal-content">
          <!----- head---->
          <div class="modal-header">
            <cfif not len(trim(attributes.BlockModal))><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button></cfif>
            <h4 class="modal-title" id="myModalLabel"><cfoutput>#Attributes.title#</cfoutput></h4>
          </div>
        <!---- body----->
          <div class="modal-body" id="contenidoConfirm<cfoutput>#Attributes.indice#</cfoutput>">
         
            <cfinclude template="/sif/TagsSIF/conlisConfirm-TablaDinamica.cfm">
            
          </div>
          <!----- FOOTER--->
              <div class="modal-footer">
                <cfif Attributes.ShowButtons NEQ 'false'>
                  <cfloop list="#Attributes.Botones#" index="ItemBoton">
                    <cfif ItemBoton EQ 'Cerrar' or ( listlen(Attributes.Botones) eq listFind(Attributes.Botones, ItemBoton))>
                      <button type="button" class="btn btn-default" data-dismiss="modal" onclick="<cfoutput>if(typeof fn#ItemBoton# == 'function') fn#ItemBoton#();</cfoutput>"/>
                    <cfelse>
                      <cfset pos = listFind(Attributes.Botones, ItemBoton)>
                      <cfset LvarFuncion = listGetAt(Attributes.Funciones, pos)>
                      <button type="button" class="btn btn-primary" onclick="<cfoutput><cfif LEN(TRIM(LvarFuncion))>if(typeof #LvarFuncion# == 'function') #LvarFuncion#();<cfelse>if(typeof fn#ItemBoton# == 'function') fn#ItemBoton#();</cfif></cfoutput>"/>
                    </cfif>
                    <cfoutput>#ItemBoton#</cfoutput>
                    </button>
                  </cfloop>
                </cfif>
              </div>
          <!---- fin footer--->    
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->

	
	<script language="javascript" type="text/javascript">
        function PopUpAbrir<cfoutput>conlis#Attributes.indice#</cfoutput>(){
         $('#myModal<cfoutput>#Attributes.indice#</cfoutput>').modal('show'); 
        }
        function PopUpCerrar<cfoutput>conlis#Attributes.indice#</cfoutput>(){
          $('#myModal<cfoutput>#Attributes.indice#</cfoutput>').modal('hide');
        }

		$( document ).ready(function() {
		
			inicializarTabla<cfoutput>conlis#Attributes.indice#</cfoutput>();
		});


		 
	</script>






<cfset indice = 1>
<label> <strong> <cfoutput>#Attributes.label#</cfoutput></strong></label>
<cfif len(attributes.values)>
  

  <cfloop array="#ArrayIds#" index="varX">
  	<cfif ArrayMostrar[indice] EQ 'S'>
  		<cfoutput>
  			<input type="text" id="#ArrayIds[indice]#" name ="#ArrayIds[indice]#" style="width:#ArrayTamanoInputs[indice]#" value="#trim(ArrayValues[indice])#" readonly="true">
  		</cfoutput>
  	<cfelse>
  		<cfoutput>
  			<input type="hidden" id="#ArrayIds[indice]#" name ="#ArrayIds[indice]#" style="width:#ArrayTamanoInputs[indice]#" value="#trim(ArrayValues[indice])#" readonly="true">
  		</cfoutput>
  	</cfif>

  <cfset indice = indice+1>

  </cfloop>

<cfelse>
  <cfloop array="#ArrayIds#" index="varX">
    <cfif ArrayMostrar[indice] EQ 'S'>
      <cfoutput>
        <input type="text" id="#ArrayIds[indice]#"  name ="#ArrayIds[indice]#" style="width:#ArrayTamanoInputs[indice]#" readonly="true" >
      </cfoutput>
    <cfelse>
      <cfoutput>
        <input type="hidden" id="#ArrayIds[indice]#" name ="#ArrayIds[indice]#" style="width:#ArrayTamanoInputs[indice]#" readonly="true">
      </cfoutput>
    </cfif>

  <cfset indice = indice+1>

  </cfloop>


</cfif>

<cfif attributes.disable EQ "N">
  
  <cfoutput>
  	<i class="fa fa-search" onclick= "PopUpAbrirconlis#Attributes.indice#()"></i>
  </cfoutput>

</cfif>


