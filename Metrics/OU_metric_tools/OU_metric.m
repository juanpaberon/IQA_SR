function eval = OU_metric(im_feats,inv_diag_covM,mu)

    eval = sqrt(((im_feats-mu).*inv_diag_covM.^2)'*(im_feats-mu));

end