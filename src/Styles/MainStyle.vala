namespace Styles { 

    public const string main_style = """
    
        .content_stack {
            background: #fff;
        }

        .scan {
            border-radius: 0;
            border: 1px solid #e1e1e1;
            background-color: alpha(#e1e1e1, 0.25);
        }

        .scan:focus {
            background-color: transparent;
        }

        .scan:selected {
            background-color: alpha(#00d050, 0.25);
        }

    """;

}