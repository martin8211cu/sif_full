

<div id ="divTablaConlis<cfoutput>#Attributes.indice#</cfoutput>">
	<table id="tablaConlis<cfoutput>#Attributes.indice#</cfoutput>" class="display table-striped table-bordered" cellspacing="0" width="100%">
			<thead align="center">
				<tr>
					<cfloop from="1" to="#Arraylen(ArrayNombreColumnasTabla)#" index="i">
						<cfoutput>
							<cfif ArrayMostrar[i] EQ 'S'>
								<th align = "center">#ArrayNombreColumnasTabla[i]#</th>	
							</cfif>
							
						</cfoutput>
					</cfloop>

				</tr>

			</thead>

			<tfoot>
				<tr>
					<cfloop from="1" to="#Arraylen(ArrayNombreColumnasTabla)#" index="i">
						<cfoutput>
							<cfif ArrayMostrar[i] EQ 'S'>
								<th align = "center">#ArrayNombreColumnasTabla[i]#</th>	
							</cfif>
							
						</cfoutput>
					</cfloop>

				</tr>
			</tfoot>
			<tbody>
				

			</tbody>

		</table>
	

	
</div>
<script src="/cfmx/commons/js/jquery.dataTables.min.js"></script>
<script language="javascript" type="text/javascript">
	

	function inicializarTabla<cfoutput>conlis#Attributes.indice#</cfoutput>(){
		var queryInicializarTabla = "<cfoutput>#replace(Attributes.query,chr(13)&chr(10),' ','all')#</cfoutput>";
		
			$('#tablaConlis<cfoutput>#Attributes.indice#</cfoutput>').dataTable( {
	        "processing": true,
	        "serverSide": true,
	        "bFilter"   : true,
	        "bSort": false,
	        "ajax": {
	            "url": "/cfmx/sif/TagsSIF/conlisConfirm-Consulta.cfm",
	            "type": "POST",
	             "data": {
	                "Query"                :queryInicializarTabla,
	                "Columnas"             :"<cfoutput>#Attributes.columnas#</cfoutput>"<cfif arrayLen(#ArrayColumnasAFiltrar#) GT 0>,
	                	
	                "ColumnasAFiltrar"     :"<cfoutput>#Attributes.columnasAFiltrar#</cfoutput>" ,
	                "TipoColumnasAFiltrar" :"<cfoutput>#Attributes.tipoColumnasAFiltrar#</cfoutput>"
	                </cfif>


	            }
	        },

	        "oLanguage": {
	        	"oPaginate" :{
	        		"sFirst": '<i class="fa fa-angle-double-left fa-5"></i>',
	        		"sLast": '<i class="fa fa-angle-double-right fa-5"></i>',
	        		"sNext": '<i class="fa fa-angle-right fa-3"></i>',
	        		"sPrevious": '<i class="fa fa-angle-left fa-3"></i>' 


	        	},
	        	"sProcessing": "Cargando",
	            "sSearch": "Buscar:",
	            "sInfo": "Se muestra desde el registro _START_ al registro _END_. Hay un total de _TOTAL_ registros.",
	            "sInfoFiltered": "Filtrado de un total de _MAX_ registros",
	            "sZeroRecords" : 'No se encontraron datos basados en los parámetros de búsqueda.',
	            "sLengthMenu": 'Mostrar <select>' +
			    '<option value="5">5</option>' +
			    '<option value="10">10</option>' +
			    '<option value="15">15</option>' +
			    '<option value="20">20</option>' +
			    '<option value="25">25</option>' +
			    '<option value="50">50</option>' +
			    '<option value="75">75</option>' +
			    '<option value="100">100</option>' +
			    '</select> resultados'
		     },
        	
	        "columns": [
	        	<cfloop from="1" to="#ArrayLen(ArrayColumnasTabla)#" index="i">
	        		<cfoutput>{ "data": "#ArrayColumnasTabla[i]#" }<cfif i NEQ ArrayLen(ArrayColumnasTabla)>,</cfif>
	        		</cfoutput>
	        	</cfloop>
	           
	        ],
	        "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull) {
	           
	            $(nRow).bind("click", function(){ ActualizaCampos<cfoutput>conlis#Attributes.indice#</cfoutput>(<cfloop from="1" to="#ArrayLen(ArrayColumnas)#" index="i"><cfoutput>aData['#ArrayColumnas[i]#']<cfif i NEQ ArrayLen(ArrayColumnas)>,</cfif></cfoutput></cfloop>); });

	            return nRow;
        	}

    	} );
	}

	<cfsavecontent variable="parametrosActualizaCampos">
		<cfoutput>  
			<cfloop from="1" to="#ArrayLen(ArrayColumnas)#" index="i"> #ArrayColumnas[i]# <cfif i NEQ ArrayLen(ArrayColumnas)>,</cfif> </cfloop> </cfoutput> 	
	</cfsavecontent>
	function ActualizaCampos<cfoutput>conlis#Attributes.indice#</cfoutput>(<cfoutput> #parametrosActualizaCampos# </cfoutput>){
		
		
			<cfloop from="1" to="#ArrayLen(ArrayColumnas)#" index="i">
				$("#<cfoutput>#ArrayIds[i]#</cfoutput>").val($.trim(<cfoutput>#ArrayColumnas[i]#</cfoutput>));
			</cfloop>

			<cfloop from="1" to="#ArrayLen(ArrayColumnas)#" index="i">
				$("#<cfoutput>#ArrayIds[i]#</cfoutput>").trigger("change");
			</cfloop>
		<cfoutput>PopUpCerrarconlis#Attributes.indice#();</cfoutput>
		
	}

</script>


