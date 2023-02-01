# Load the dplyr package
library("dplyr")
library("DALEX")
library(MlBayesOpt)
require(xgboost)


columns_name = c("LHS","Cu", "CuCl", "CuOH", "CuO", "Cu2O", 
                 "Acc_Cu", "Acc_CuCl", "Acc_CuOH", "Acc_CuO", "Acc_Cu2O",
                 "seg_all_acc", "seg_all_rust")

prior <- c("Cu", "CuCl", "CuOH", "CuO", "Cu2O")
label <- c("Acc_Cu","seg_all_rust")

data <- data.frame(read.csv("valid-LHS-res.csv", sep = "\t"))
# Rename all column names
colnames(data) <- columns_name
                   
input <- data %>% select(c(prior, label))

#create ID column
input$id <- 1:nrow(input)

#use 70% of dataset as training set and 30% as test set 
train <- input %>% dplyr::sample_frac(0.70)
test  <- dplyr::anti_join(input, train, by = 'id')



es0 <- xgb_opt(train_data = train,
               train_label = label,
               test_data = test,
               test_label = label,
                   objectfun = "reg:linear",
                   evalmetric = "rmse",
                   classes = 1,
                   init_points = 50,
                   n_iter = 1)
