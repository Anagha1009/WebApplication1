<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cats.aspx.cs" Inherits="WebApplication1.Cats" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous" />
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <!-- SweetAlert2 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.2.0/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.2.0/sweetalert2.min.css" />

    <!--Datatable-->
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/dataTables.bootstrap4.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.2/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="https://cdn.datatables.net/1.10.25/css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-4 col-12"></div>
                <div class="col-lg-4 text-center col-12">
                    <h3>Cats List</h3>
                </div>
                <div class="col-lg-4 text-right col-12">
                    <asp:Button ID="BtnAdd" runat="server" class="btn btn-dark mt-4" OnClick="BtnAdd_Click" Text="Add New Cats" />
                </div>
            </div>
            <!-- The Modal -->
            <div class="modal" id="myModal">
                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                    <div class="modal-content">
                        <!-- Modal Header -->
                        <div class="modal-header">
                            <h4 class="modal-title">Add New Cats</h4>
                            <asp:HiddenField ID="HFRowId" runat="server" />
                            <asp:HiddenField ID="HFExisImage" runat="server" />
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>

                        <!-- Modal body -->
                        <div class="modal-body">
                            <div class="my-3">
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Name
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtName" runat="server" class="form-control" MaxLength="50" placeholder="Enter Name"></asp:TextBox>
                                    </div>
                                </div>                               
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Weight
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtWeight" runat="server" class="form-control" MaxLength="5" onkeypress="return checkPosInt(this,event)" placeholder="Enter Weight"></asp:TextBox>
                                    </div>
                                </div>                              
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Cat's Image
                                    </div>
                                    <div class="col-6">
                                        <asp:FileUpload ID="FUImg" runat="server" class="form-control" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Gender
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:RadioButtonList ID="RdbtnGender" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Male" Value="0" Selected="True"></asp:ListItem>
                                            <asp:ListItem Text="Female" Value="1"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>                              
                            </div>
                        
                        <!-- Modal footer -->
                        <div class="modal-footer mx-auto">
                            <asp:Button ID="BtnSave" runat="server" Text="Save" class="btn btn-success" OnClientClick="return ValidateForm();" />
                        </div>

                    </div>
                </div>
            </div>

            <div class="mt-3 scrollbar">
                <asp:Repeater ID="RptrCats" runat="server">
                    <HeaderTemplate>
                        <table id="CatsTable" class="table table-bordered text-center">
                            <thead>
                                <tr>
                                    <td>Name</td>
                                    <td>Weight</td>
                                    <td>Gender</td>                                    
                                    <td>Image</td>                                   
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("Name") %></td>
                            <td><%# Eval("Weight") %></td>                            
                            <td><%# getGender(Eval("Gender").ToString()) %></td>                           
                            <td>
                                <asp:Image ID="ImgCats" runat="server" Height="50px" Width="50px" ImageUrl='<%# "/Uploads/Cats/" + Eval("CatImage") %>' />
                                <asp:Label ID="LblNoImage" runat="server" Visible="false" Text="No Image"></asp:Label>
                            </td>                           
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </tbody>                   
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>

    </form>
</body>
    <script>
        function checkPosInt(txt,evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode == 46) {
                //Check if the text already contains the . character
                if (txt.value.indexOf('.') === -1) {
                    return true;
                } else {
                    return false;
                }
            } else {
                if (charCode > 31 &&
                    (charCode < 48 || charCode > 57))
                    return false;
            }
            return true;
            
        }

        function ValidateForm() {
            if (document.getElementById('<%=TxtName.ClientID%>').value == '') {
                alert("Please enter Cat's Name");
                document.getElementById('<%=TxtName.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtWeight.ClientID%>').value == '') {
                alert("Please enter Cat's Weight");
                document.getElementById('<%=TxtWeight.ClientID%>').focus();
                return false;
            }
            return true;
        }

    </script>
</html>
